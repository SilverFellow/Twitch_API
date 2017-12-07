# frozen_string_literal: true

require_relative 'clip_representer'

module LoyalFan
  # Representer for Twitch channel information
  class ChannelRepresenter < Roar::Decorator
    include Roar::JSON

    property :id
    property :url
    property :name
    property :user_id
    property :live
    property :title
    property :game
    property :viewer
    property :logo
    collection :clips, extend: ClipRepresenter, class: OpenStruct
  end
end
