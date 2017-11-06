# frozen_string_literal: true

module API
  module Database
    # Object-Relational Mapper for Clips
    class ClipOrm < Sequel::Model(:clips)
      many_to_many :owned_channels,
                   join_table: :channels_clips,
                   left_key: :clip_id, right_key: :channel_id

      many_to_many :owned_games,
                   join_table: :games_clips,
                   left_key: :clip_id, right_key: :game_id

      plugin :timestamps, update_on_create: true
    end
  end
end
