# frozen_string_literal: true

require 'roda'
require 'econfig'
require_relative 'init.rb'

module API
  # Web API
  class Api < Roda
    plugin :environments
    plugin :json
    plugin :halt

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    route do |routing|
      app = Api
      config = Api.config
      gh = Twitch::TwitchGateway.new(config.token)

      routing.root do
        { 'message' => "Twitch API v0.1 up in #{app.environment}" }
      end

      routing.on 'api' do
        routing.on 'v0.1' do
          routing.on 'game', String do |game_name|
            routing.get do
              find_result = FindDatabaseGame.call(
                game_name: game_name
              )

              http_response = HttpResponseRepresenter.new(find_result.value)
              response.status = http_response.http_code
              if find_result.success?
                GameRepresenter.new(find_result.value.message).to_json
              else
                http_response.to_json
              end
            end

            routing.post do
              service_result = LoadGameFromTwitch.new.call(
                config: gh,
                game_name: game_name
              )

              http_response = HttpResponseRepresenter.new(service_result.value)
              response.status = http_response.http_code
              if service_result.success?
                response['Location'] = "/api/v0.1/game/#{game_name}"
                GameRepresenter.new(service_result.value.message).to_json
              else
                http_response.to_json
              end
            end
          end

          routing.on 'channel', String do |channel_name|
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
  end
end
