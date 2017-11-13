# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:clips) do
      primary_key :id

      String :title
      String :url
      Int :view
      String :source
      String :name

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
