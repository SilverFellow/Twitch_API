# frozen_string_literal: true

module API
  module Repository
    For = {
      Entity::Channel  => Channels,
      Entity::Game     => Games,
      Entity::Clip     => Clips
    }.freeze
  end
end
