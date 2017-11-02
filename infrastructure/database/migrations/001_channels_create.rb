# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:channels) do
      primary_key :id
      foreign_key :clip_title, :clips
      foreign_key :clip_url, :clips

      String :url 
      Int :user_id, unique: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
