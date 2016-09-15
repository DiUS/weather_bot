require 'sinatra'
require 'json'

post '/gateway' do
  content_type :json
  { text: 'hello world!!!' }.to_json
end
