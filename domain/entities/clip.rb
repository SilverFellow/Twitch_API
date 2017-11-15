# frozen_string_literal: false

require 'dry-struct'

module LoyalFan
  module Entity
    # entity for twitch clip
    class Clip < Dry::Struct
      attribute :id, Types::Int.optional
      attribute :title, Types::Strict::String
      attribute :url, Types::Coercible::String
      attribute :view, Types::Coercible::Int
      attribute :source, Types::Strict::String
      attribute :name, Types::Strict::String
    end
  end
end
