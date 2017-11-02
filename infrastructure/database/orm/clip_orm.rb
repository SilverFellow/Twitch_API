# frozen_string_literal: true

module API
  module Database
    # Object-Relational Mapper for Clips
    class ClipOrm < Sequel::Model(:clips)
      one_to_one :source,
                 key: :source

      one_to_many :clip_titles,
                  class: :'API::Database::ClipOrm',
                  key: :title

      one_to_many :clip_urls,
                  class: :'API::Database::ClipOrm',
                  key: :url

      plugin :timestamps, update_on_create: true
    end
  end
end
