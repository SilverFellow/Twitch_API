# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:clips) do
      primary_key :title, :url
      
      Int :views
      String :source
      String :name

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
