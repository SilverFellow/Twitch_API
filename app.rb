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

      # GET / request
      routing.root do
        { 'message' => "Twitch API v0.1 up in #{app.environment}" }
      end

      routing.on 'api' do
        routing.on 'game', String do |game_name|
          gh = Twitch::TwitchGateway.new(config.token)
          game_mapper = Twitch::GameMapper.new(gh)
          begin
            game = game_mapper.load(game_name)
          rescue StandardError
            routing.halt(404, error: 'game not found')
          end

          routing.is do
            { info: game.to_h }
          end

          routing.get 'name' do
            { name: game.name }
          end

          routing.get 'number' do
            { number: game.number }
          end

          routing.get 'clips' do
            { clips: game.clips.to_s }
          end

          routing.get 'streamers' do
            { streamers: game.streamers }
          end
        end

        
      end
    end
  end
end
