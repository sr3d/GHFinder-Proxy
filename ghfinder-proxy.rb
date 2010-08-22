# You'll need to require these if you
# want to develop while running with ruby.
# The config/rackup.ru requires these as well
# for it's own reasons.
#
# $ ruby heroku-sinatra-app.rb
#
require 'rubygems'
require 'sinatra'
require 'curb'

configure :production do
end

JS_ESCAPE_MAP = { '\\' => '\\\\', '</' => '<\/', "\r\n" => '\n', "\n" => '\n', "\r" => '\n', '"' => '\\"', "'" => "\\'" }

def escape_javascript(javascript)
  if javascript
    javascript.gsub(/(\\|<\/|\r\n|[\n\r"'])/) { JS_ESCAPE_MAP[$1] }
  else
    ''
  end
end


get '/' do
  url       = params[:url]
  callback  = params[:callback]
  
  halt 401, 'invalid url' unless /http:\/\/github.com/i =~ url
  
  html = Curl::Easy.perform url
  
  callback.nil? ? html.body_str : "#{callback}(\"#{escape_javascript(html.body_str)})\")"
end