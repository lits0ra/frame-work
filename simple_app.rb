require 'json'
require 'erb'

class SimpleApp
  HASH = {}
  @@not_found_response = "<h1>404 Not found</h1>"
  def call(env)
    request_path = env['REQUEST_PATH']
    block = HASH[request_path]
    if block.nil?
      return [
        200,
        { 'Content-Type' => 'text/html' },
        [@@not_found_response]
      ]
    else
      return block&.call
    end
  end
end

def get(route, &block)
  SimpleApp::HASH.store(route, block)
end

def find_template(name, format)
  if format == :erb
    template = File.open(name, 'r', &:read)
    erb_engin = ERB.new(template)
    erb_engin.result
  elsif format == :html
    File.open(name, 'r', &:read)
  elsif format == :json
    JSON.generate(name)
  end
end

def compile_template(name, format)
  text(find_template(name, format))
end

def text(txt)
  [
    200,
    { 'Content-Type' => 'text/html' },
    [txt]
  ]
end

def json(json)
  compile_template(json, :json)
end

def html(name)
  compile_template(name, :html)
end

def erb(name)
  compile_template(name, :erb)
end
