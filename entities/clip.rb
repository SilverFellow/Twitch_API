# frozen_string_literal: false

require 'dry-struct'

module API
  module Entity
    # entity for twitch channel
    class Clip < Dry::Struct
      attribute :title, Types::Strict::String.optional
      attribute :url, Types::Coercible::String.optional
    end
  end
end