# frozen_string_literal: true

require 'roda'

module LoyalFan
  # Web API
  class Api < Roda
    plugin :all_verbs
    plugin :multi_route

    require_relative 'channel'

    def represent_response(result, representer_class)
      http_response = HttpResponseRepresenter.new(result.value)
      response.status = http_response.http_code
      message = result.value.message
      message = message[:response] if message.is_a?(Hash)
      if result.success?
        yield if block_given?
        representer_class.new(message).to_json
      else
        http_response.to_json
      end
    end

    route do |routing|
      response['Content-Type'] = 'application/json'
      # app = Api
      # config = Api.config
      # gh = Twitch::TwitchGateway.new(config.TWITCH_TOKEN)

      routing.root do
        message = "Twitch API v0.1 up in #{Api.environment} mode"
        HttpResponseRepresenter.new(Result.new(:ok, message)).to_json
      end

      routing.on 'api' do
        routing.on 'v0.1' do
          @api_root = '/api/v0.1'
          routing.multi_route
        end
      end
    end
  end
end
