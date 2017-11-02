# frozen_string_literal: false

require 'dry-struct'
require_relative 'clip.rb'

module API
  module Entity
    # entity for twitch channel
    class Game < Dry::Struct
      attribute :id, Types::Int.optional
      attribute :name, Types::Strict::String.optional
      attribute :clips, Types::Strict::Array.member(Clip).optional
      attribute :streamers, Types::Strict::Hash.optional
    end
  end
end
