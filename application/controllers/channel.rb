# frozen_string_literal: true

module LoyalFan
  # Web API
  class Api < Roda
    plugin :all_verbs

    route('channel') do |routing|
      gw = Twitch::TwitchGateway.new(Api.config.TWITCH_TOKEN)

      # #{API_ROOT}/channel/:channel_name
      routing.on String do |channel_name|
        routing.get do
          find_result = FindDatabaseChannel.call(
            token: Api.config.TWITCH_TOKEN, channel_name: channel_name
          )

          represent_response(find_result, ChannelRepresenter)
        end

        routing.post do
          load_result = LoadChannelFromTwitch.new.call(
            gateway: gw, channel_name: channel_name
          )

          represent_response(load_result, ChannelRepresenter) do
            response['Location'] = "#{@api_root}/channel/#{channel_name}"
          end
        end
      end
    end
  end
end
