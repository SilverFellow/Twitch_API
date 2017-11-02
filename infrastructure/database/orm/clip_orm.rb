# frozen_string_literal: true

module API
  module Database
    # Object-Relational Mapper for Clips
    class ClipOrm < Sequel::Model(:clips)
      many_to_one :channel,
                  class: :'API::Database::ChannelOrm'

      many_to_one :game,
                  class: :'API::Database::GameOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
