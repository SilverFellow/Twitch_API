# frozen_string_literal: true

module API
  module Database
    # Object-Relational Mapper for Channels
    class ChannelOrm < Sequel::Model(:channels)
      one_to_one  :name,
                  key: :name
      
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
