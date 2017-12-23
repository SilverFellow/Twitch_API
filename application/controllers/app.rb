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
