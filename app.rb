require 'sinatra'
require 'kramdown'
require 'safe_yaml'
require 'open-uri'
require 'liquid'

YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m

set :bind, '0.0.0.0'

get '/' do

  # defaults you can override in the head of your readme
  data = {
    'footnote' => '<hr>Powered by <a href=https://github.com/play-with-docker/play-with-docker>PWD</a> and <a href=https://github.com/jonocodes/pwder/>PWDer</a>'
  }

  if params['template']
    begin
      template = open(params['template']) { |io| _data = io.read }
    rescue OpenURI::HTTPError
      ; # TODO: log error
    end
  end

  template = File.read("#{__dir__}/default.html") if not template

  begin
    doc = open(params['doc']) { |io| _data = io.read }

    markdown = doc

    if doc =~ YAML_FRONT_MATTER_REGEXP
      markdown = $'
      data_file = SafeYAML.load(Regexp.last_match(1))
      data.merge!(data_file)
    end

    data['content'] = Kramdown::Document.new(markdown, :input => 'GFM').to_html

  rescue OpenURI::HTTPError

    # TODO: log error

    about = File.read("#{__dir__}/about.html")
    
    data['terms'] = 0
    data['title'] = 'not found'
    data['content'] = Liquid::Template.parse(about).render( {
      'error' => "Error loading readme: <a href=#{params['doc']}>#{params['doc']}</a>" } )
  end

  Liquid::Template.parse(template).render( data )

end
