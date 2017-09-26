require 'sinatra'
require 'kramdown'
require 'safe_yaml'
require 'open-uri'
require 'liquid'

YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m

get '/' do

  # defaults
  data = {
    'title' => 'not found',
    'hide_footer' => false
  }

  # TODO: allow setting template from http file via query param ?remote_template=http://...

  template = File.read("#{__dir__}/default.html")

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

    about = File.read("#{__dir__}/about.html")
    data['terms'] = 0
    data['content'] = Liquid::Template.parse(about).render( {
      'error' => "Error loading readme: <a href=#{params['doc']}>#{params['doc']}</a>" } )
  end

  Liquid::Template.parse(template).render( data )

end
