# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:games_channels) do
      foreign_key :game_id, :games
      foreign_key :channel_id, :channels
      primary_key [:game_id, :channel_id]
      index [:game_id, :channel_id]
    end
  end
end
