# frozen_string_literal: false

require 'dry-struct'
require_relative 'clip.rb'

module API
  module Entity
    # entity for twitch channel
    class Channel < Dry::Struct
      attribute :live, Types::Strict::Bool
      attribute :name, Types::Strict::String.optional
      attribute :title, Types::Strict::String.optional
      attribute :game, Types::Strict::String.optional
      attribute :viewer, Types::Coercible::Int.optional
      attribute :clips, Types::Strict::Array.member(Clip).optional
    end
  end
end
