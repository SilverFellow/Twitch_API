# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:channels_clips) do
      foreign_key :channel_id, :channels
      foreign_key :clip_id, :clips
      primary_key %i[channel_id clip_id]
      index %i[channel_id clip_id]
    end
  end
end
