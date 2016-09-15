require 'sinatra'
require 'json'
require_relative 'weather_reader'

post '/gateway' do
  weather_bot = WeatherReader.new
  message = params[:text].gsub(params[:trigger_word], '').strip
  puts "--------------------- received message: #{message}"
  result = weather_bot.process_command(message)

  content_type :json
  { text: result }.to_json
end
