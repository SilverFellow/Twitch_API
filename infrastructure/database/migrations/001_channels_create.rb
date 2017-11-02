# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:channels) do
      primary_key :name
      foreign_key :clip_title, :clips
      foreign_key :clip_url, :clips

      String      :user_id, unique: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
