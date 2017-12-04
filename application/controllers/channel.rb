# frozen_string_literal: true

require 'roda'
require 'econfig'
# require_relative 'init.rb'

module LoyalFan
  # Web API
  class Api < Roda
    plugin :environments
    plugin :json
    plugin :halt

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'
    
    route('channel') do |routing|
      app = Api
      config = Api.config
      gh = Twitch::TwitchGateway.new(config.TWITCH_TOKEN)
      routing.on String do |channel_name|
        routing.get do
          find_result = FindDatabaseChannel.call(
            channel_name: channel_name
          )

          http_response = HttpResponseRepresenter.new(find_result.value)
          response.status = http_response.http_code
          if find_result.success?
            ChannelRepresenter.new(find_result.value.message).to_json
          else
            http_response.to_json
          end
        end

        routing.post do
          service_result = LoadChannelFromTwitch.new.call(
            config: gh,
            channel_name: channel_name
          )

          http_response = HttpResponseRepresenter.new(service_result.value)
          response.status = http_response.http_code
          if service_result.success?
            response['Location'] = "/api/v0.1/channel/#{channel_name}"
            ChannelRepresenter.new(service_result.value.message).to_json
          else
            http_response.to_json
          end
        end
      end
    end
  end
end