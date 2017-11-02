# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:games) do
      primary_key :name
      foreign_key :clip_title, :clips
      foreign_key :clip_url, :clips

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
