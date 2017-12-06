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
    plugin :multi_route

    require_relative 'channel'

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    route do |routing|
      app = Api
      config = Api.config
      gh = Twitch::TwitchGateway.new(config.TWITCH_TOKEN)

      routing.root do
        message = "Twitch API v0.1 up in #{app.environment} mode"
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
