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
              response = Repository::For[Entity::Game].find_unofficial_name(game_name)
              routing.halt(404, error: 'Game not found') unless response
              response.to_h
            end

            routing.post do
              begin
                game = Twitch::GameMapper.new(gh).load(game_name)
              rescue StandardError
                routing.halt(404, error: 'Game not found')
              end
              stored_game = Repository::For[game.class].find_or_create(game)
              response.status = 201
              response['Location'] = "/api/v0.1/game/#{game_name}"
              stored_game.to_h
              # p stored_game.clips[0].title
              # p stored_game.channels[0].url
            end
          end

          routing.on 'channel', String do |channel_name|
            routing.get do
              response = Repository::For[Entity::Channel].find_url(channel_name)
              routing.halt(404, error: 'Channel not found') unless response
              response.to_h
            end

            routing.post do
              begin
                channel = Twitch::ChannelMapper.new(gh).load(channel_name)
              rescue StandardError
                routing.halt(404, error: 'Channel not found') 
              end
              stored_channel = Repository::For[channel.class].find_or_create(channel)
              response.status = 201
              response['Location'] = "/api/v0.1/channel/#{channel_name}"
              stored_channel.to_h
              # p stored_game.clips[0].title
              # p stored_game.channels[0].url
            end
          end
        end
      end
    end
  end
end
