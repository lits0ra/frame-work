require 'json'
require 'tilt'

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

def find_template(name)
  File.open(name, 'r', &:read)
end

def compile_template(name, format)
  tiltEngine = Tilt[name]
  if tiltEngine.nil?
    raise ".#{format} template engine not found!"
  end
  # template = File.open(name, 'r', &:read)
  erb_engin = Tilt.new(name)
  text(erb_engin.render)
end

def text(txt)
  [
    200,
    { 'Content-Type' => 'text/html' },
    [txt]
  ]
end

def json(json)
  text(JSON.generate(json))
end

def html(name)
  compile_template(name, :html)
end

def erb(name)
  compile_template(name, :erb)
end
