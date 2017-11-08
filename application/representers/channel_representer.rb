# frozen_string_literal: true

require_relative 'clip_representer'

module API
  class ChannelRepresenter < Roar::Decorator
    include Roar::JSON

    property :id
    property :url
    property :user_id
    property :live
    property :title
    property :game
    property :viewer
    collection :clips, extend: ClipRepresenter
    
  end
end