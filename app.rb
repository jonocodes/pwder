require 'sinatra'
require 'kramdown'
require 'safe_yaml'
require 'open-uri'
require 'liquid'
require 'oga'
require 'socket'
require 'yaml'

YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m

PWDERIFY_ALT='Make document interactive using pwder.io'

set :bind, '0.0.0.0'

configure do
  set :server, :puma
  set :start_time, Time.now
end

def about(error="")
  {
    'terms' => 0,
    'content' => Liquid::Template.parse(File.read("#{__dir__}/about.liquid")
      ).render( {'error' => error} )
  }
end

def build_info()
  # TODO: make sure this short circut works as expected
  # TODO: gracefully ignore if file is not found
  build_info ||= YAML.load_file('build_info.yml')
end

def fetch_doc(path, shorthand=nil)

  if (shorthand == 'gh')
    path = 'https://raw.githubusercontent.com/' + path
  elsif (shorthand == 'gst')
    path = 'https://gist.githubusercontent.com/' + path
  elsif (shorthand == 'examples')
    logger.debug("Reading local file #{__dir__}/examples/#{path}")
    # TODO: make sure path is sub of dir and cant go above
    return File.read("#{__dir__}/examples/#{path}")
  elsif (shorthand == 'here' and ENV['PWDER_HERE_DIR'])
    return File.read("#{ENV['PWDER_HERE_DIR']}/#{path}")
  elsif (shorthand != nil)
    # TODO: error out = invalid shorthand
  end

  # fix entries that point to github to point to the raw version instead
  if (path.match(/^https:\/\/github.com/))
    path.sub!(/^https:\/\/github.com\/([^\/]*)\/([^\/]*)\/blob/, "https://raw.githubusercontent.com/\\1/\\2")
  end

  # TODO: fix this sloppy way of passing value back up
  params['sourcelink'] = "<a href=#{path} target=_blank>Document source</a>"

  open(path) { |io| _data = io.read }

end

def show()
  # defaults you can override in the head of your readme
  data = {
    'footnote' => 'Powered by <a href=https://github.com/play-with-docker/play-with-docker target=_blank>PWD</a> and <a href=https://github.com/jonocodes/pwder/ target=_blank>PWDer</a>'
  }

  if params['template']
    begin
      template = open(params['template']) { |io| _data = io.read }
    rescue OpenURI::HTTPError => e
      logger.error "Trying to load template #{params['template']} ... #{e.message}"
    end
  end

  template = File.read("#{__dir__}/default.liquid") if not template

  if not params['doc']
    data = data.merge(about())
  else
    begin

      doc = fetch_doc(params['doc'], params['shorthand'])

      # parse the front matter
      if doc =~ YAML_FRONT_MATTER_REGEXP
        doc = $'
        data.merge!(SafeYAML.load(Regexp.last_match(1)))
      end

      # override front matter with optional query params
      params['terms'] = Integer(params['terms']) if params.key?('terms')
      data.merge!(params)

      data['content'] = Kramdown::Document.new(doc,
        {input: 'GFM', syntax_highlighter: 'rouge'}).to_html

      # remove the pwderify badge since we dont want to render it
      if data['content'].include? PWDERIFY_ALT
        _doc = Oga.parse_html(data['content'])
        _doc.xpath("//a/img[@alt=\"#{PWDERIFY_ALT}\"]").remove
        data['content'] = _doc.to_xml

      end

      data['sourcelink'] = params['sourcelink']

    rescue Exception => e
      logger.error "Trying loading doc #{params['doc']} ... #{e.message}"

      data = data.merge(about("Error loading/finding document <a href=#{params['doc']}>#{params['doc']}</a>"))
    end
  end

  Liquid::Template.parse(template).render(data)
end

# sinatra routes

get '/status' do
  content_type :json

  { :hostname => Socket.gethostname,
    :start_time => settings.start_time,
    :now => Time.now,
    :uptime_hours => (Time.now - settings.start_time) / 3600,
    # :git_branch
    # :git_checksum
    # :docker_tag
    # :docker_checksum
    # :build_date
  }.merge(build_info).to_json
end

get '/static/*' do |path|
  # TODO: make sure this is safe and wont fetch files outside static/
  send_file "#{__dir__}/static/#{path}"
end

get '/*/*' do |shorthand, path|
  params['shorthand'] = shorthand
  params['doc'] = path
  show()
end


# get '/pwderify' do
#   logger.info "REFERER: #{request.referer}"
#   # TODO: capturing referer wont work coming from github until pwder uses TLS
#   # redirect to("/?doc=#{request.referrer}")
#   show()
# end

get '/' do
  show()
end
