require 'sinatra'
require 'kramdown'
require 'safe_yaml'
require 'open-uri'
require 'liquid'

YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m

set :bind, '0.0.0.0'
configure { set :server, :puma }

def about(error="")
  {
    'terms' => 0,
    'content' => Liquid::Template.parse(File.read("#{__dir__}/about.html")
      ).render( {'error' => error} )
  }
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
  end

  # TODO: else error out = invalid shorthand

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

  template = File.read("#{__dir__}/default.html") if not template

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

      data['content'] = Kramdown::Document.new(doc, :input => 'GFM').to_html

    rescue Exception => e
      logger.error "Trying loading doc #{params['doc']} ... #{e.message}"

      data = data.merge(about("Error loading/finding document <a href=#{params['doc']}>#{params['doc']}</a>"))
    end
  end

  Liquid::Template.parse(template).render(data)
end

# sinatra routes

get '/*/*' do |shorthand, path|
  params['shorthand'] = shorthand
  params['doc'] = path
  show()
end

get '/' do
  show()
end
