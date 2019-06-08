require './simple_app'

get '/name' do
  @sssss = 11
  erb("./index.erb")
end

get '/user/:id/hello' do
  @sssss = 11
  erb("./index.erb")
end
