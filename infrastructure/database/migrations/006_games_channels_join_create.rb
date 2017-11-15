# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:games_channels) do
      foreign_key :game_id, :games
      foreign_key :channel_id, :channels
      primary_key %i[game_id channel_id]
      index %i[game_id channel_id]
    end
  end
end
