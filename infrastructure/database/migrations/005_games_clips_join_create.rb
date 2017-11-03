# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:games_clips) do
      foreign_key :game_id, :games
      foreign_key :clip_id, :clips
      primary_key [:game_id, :clip_id]
      index [:game_id, :clip_id]
    end
  end
end
