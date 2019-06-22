# frozen_string_literal: true

require 'json'
require 'tilt'
require 'binding_of_caller'


class SimpleApp
  HASH = {}
  PARAMS = {}
  @a = 1
  @@not_found_response = '<h1>404 Not found</h1>'
  def self.check_path(request_path, hash_key)
    request_path_list = request_path.split('/')
    hash_keys_list = hash_key[0].split('/')
    request_path_list.zip(hash_keys_list) do |x, y|
      if x != ''
        if x != y
          if y.start_with?(':')
            y = y.sub(/:/, '')
            PARAMS.store(y, x)
          else
            return false
          end
        end
      end
    end
    return true
  end

  def call(env)
    request_path = []
    request_path.push(env['REQUEST_PATH'])
    block = nil
    HASH.each do |hash|
      request_path.each do |request_path|
        block = HASH[hash[0]] if SimpleApp.check_path(request_path, hash)
      end
    end
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

def params
  SimpleApp::PARAMS
end

def get(route, &block)
  SimpleApp::HASH.store(route, block)
end

def find_template(name)
  File.open(name, 'r', &:read)
end

def compile_template(name, format)
  variable_value = {}
  for valiable in binding.of_caller(2).eval("instance_variables")
    value = binding.of_caller(2).eval(valiable.to_s)
    p valiable
    valiable = valiable.to_s.gsub!(/@/, "")
    variable_value[valiable] = value
  end
  tiltEngine = Tilt[name]
  raise ".#{format} template engine not found!" if tiltEngine.nil?
  erb_engin = Tilt.new(name)
  text(erb_engin.render(Hash, variable_value))
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
