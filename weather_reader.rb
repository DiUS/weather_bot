require 'wit'

class WeatherReader
  def initialize
    @access_token = ENV['WIT_ACCESS_TOKEN']
    @client = Wit.new(access_token: @access_token, actions: wit_actions)
  end

  def process_command(message)
    puts  @client.converse(SecureRandom.uuid, message).inspect
    @client.converse(SecureRandom.uuid, message)['msg']
  end

  private

  def wit_actions
    {
        send: -> (_, response) {
          puts("sending... #{response['text']}")
        },
        getForecast: -> (request) {
          puts request.inspect

          context = request['context']
          entities = request['entities']
          location = first_entity_value(entities, 'location')

          if location
            # forecast = `./weather.sh #{location}`
            # if forecast.empty?
            if location
              context['unknownLocation'] = true
            else
              context['forecast'] = 'sunny'
            end
          else
            context['missingLocation'] = true
            context.delete('forecast')
          end

          return context
        }
    }
  end

  def first_entity_value(entities, entity)
    return nil unless entities.has_key? entity
    val = entities[entity][0]['value']
    return nil if val.nil?
    val.is_a?(Hash) ? val['value'] : val
  end
end
