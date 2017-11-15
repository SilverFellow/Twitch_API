# frozen_string_literal: true

module LoyalFan
  module Database
    # Object-Relational Mapper for Games
    class GameOrm < Sequel::Model(:games)
      many_to_many :clips,
                   class: :'LoyalFan::Database::ClipOrm',
                   join_table: :games_clips,
                   left_key: :game_id, right_key: :clip_id

      many_to_many :channels,
                   class: :'LoyalFan::Database::ChannelOrm',
                   join_table: :games_channels,
                   left_key: :game_id, right_key: :channel_id

      plugin :timestamps, update_on_create: true
    end
  end
end
