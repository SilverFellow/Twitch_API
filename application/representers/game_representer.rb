# frozen_string_literal: true

require_relative 'channel_representer'
require_relative 'clip_representer'

module API
  # Representer for Twitch game category information
  class GameRepresenter < Roar::Decorator
    include Roar::JSON

    property :id
    property :unofficial_name
    property :official_name
    collection :clips, extend: ClipRepresenter
    collection :channels, extend: ChannelRepresenter
  end
end
