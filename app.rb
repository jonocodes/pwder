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
      doc = open(params['doc']) { |io| _data = io.read }

      markdown = doc

      if doc =~ YAML_FRONT_MATTER_REGEXP
        markdown = $'
        data_file = SafeYAML.load(Regexp.last_match(1))
        data.merge!(data_file)
      end

      data['content'] = Kramdown::Document.new(markdown, :input => 'GFM').to_html

    rescue Exception => e
      logger.error "Trying loading doc #{params['doc']} ... #{e.message}"

      data = data.merge(about("Error loading/finding document <a href=#{params['doc']}>#{params['doc']}</a>"))
    end
  end

  Liquid::Template.parse(template).render( data )
end

# sinatra routes

get '/gh/*' do |path|
  params['doc'] = 'https://raw.githubusercontent.com/' + path
  logger.info params
  show()
end

get '/' do
  show()
end
