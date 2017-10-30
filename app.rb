# frozen_string_literal: true

require 'roda'
require 'econfig'
require_relative 'lib/init.rb'

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
        routing.on 'game', String do |game_name|
          game_mapper = Twitch::GameMapper.new(gh)
          begin
            game = game_mapper.load(game_name)
          rescue StandardError
            routing.halt(404, error: 'game not found')
          end
          routing.is do
            game.to_h
          end
        end

        routing.on 'channel', String do |channel_name|
          channel_mapper = Twitch::ChannelMapper.new(gh)

          begin
            channel = channel_mapper.load(channel_name)
          rescue StandardError
            routing.halt(404, error: 'channel not found')
          end

          routing.is do
            channel.to_h
          end
        end
      end
    end
  end
end
