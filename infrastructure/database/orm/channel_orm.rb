# frozen_string_literal: true

module LoyalFan
  module Database
    # Object-Relational Mapper for Channels
    class ChannelOrm < Sequel::Model(:channels)
      many_to_many :clips,
                   class: :'LoyalFan::Database::ClipOrm',
                   join_table: :channels_clips,
                   left_key: :channel_id, right_key: :clip_id

      many_to_many :games,
                   join_table: :games_channels,
                   left_key: :channel_id, right_key: :game_id

      plugin :timestamps, update_on_create: true
    end
  end
end
