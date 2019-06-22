require './simple_app'
require 'tilt'

get '/name' do
  @sssss = 11
  html("./index.html")
end

get '/user/:id/hello' do
  @sssss = 11
  erb("./index.erb")
end
