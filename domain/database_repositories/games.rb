# frozen_string_literal: true

module LoyalFan
  module Repository
    # Repository for Games
    class Games
      def self.find_id(id)
        db_record = Database::GameOrm.first(id: id)
        rebuild_entity(db_record)
      end

      def self.find_name(name)
        db_record = Database::GameOrm.first(name: name)
        rebuild_entity(db_record)
      end

      def self.find_or_create(entity)
        find_name(entity.name) || create_from(entity)
      end

      def self.create_from(entity)
        db_game = Database::GameOrm.create(
          name: entity.name
        )

        entity.clips.each { |clip| Clips.update_or_create(db_game, clip) }

        entity.channels.each do |channel|
          stored_channel = Channels.find_or_create(channel)
          channel = Database::ChannelOrm.first(id: stored_channel.id)
          db_game.add_channel(channel)
        end

        rebuild_entity(db_game)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        clips = db_record.clips.map do |clip|
          Clips.rebuild_entity(clip)
        end

        channels = db_record.channels.map do |channel|
          Channels.rebuild_entity(channel)
        end

        Entity::Game.new(
          id: db_record.id,
          unofficial_name: db_record.unofficial_name,
          official_name: db_record.official_name,
          clips: clips,
          channels: channels
        )
      end
    end
  end
end
