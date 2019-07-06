require './simple_app'

get '/hello' do
  @sssss = 11
  html("./index.html")
end
