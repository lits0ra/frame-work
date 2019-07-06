require './simple_app'

get '/hello' do
  html("./index.html")
end
