# frozen_string_literal: true

require_relative 'channel_representer'
require_relative 'clip_representer'

module LoyalFan
  # Representer for Twitch game category information
  class GameRepresenter < Roar::Decorator
    include Roar::JSON

    property :id
    property :name
    collection :clips, extend: ClipRepresenter, class: OpenStruct
    collection :channels, extend: ChannelRepresenter, class: OpenStruct
  end
end
