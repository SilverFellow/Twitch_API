# frozen_string_literal: true

require 'roda'
require_relative 'route_helpers'

module LoyalFan
  # Web API
  class Api < Roda
    plugin :all_verbs
    plugin :multi_route

    require_relative 'channel'

    route do |routing|
      app = Api
      ENV['AWS_ACCESS_KEY_ID'] = app.config.AWS_ACCESS_KEY_ID
      ENV['AWS_SECRET_ACCESS_KEY'] = app.config.AWS_SECRET_ACCESS_KEY
      ENV['AWS_REGION'] = app.config.AWS_REGION
      
      response['Content-Type'] = 'application/json'

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
