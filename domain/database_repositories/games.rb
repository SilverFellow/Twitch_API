# frozen_string_literal: true

module API
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

        entity.clips.each do |clip|
          stored_clip = Clips.find_or_create(clip.title)
          clip = Database::Clip.first(id: stored_clip.id)
          db_channel.add_clip(clip)
        end

        rebuild_entity(db_channel)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        clips = db_record.clips.map do |clip|
          Clips.rebuild_entity(clip)
        end

        Entity::Game.new(
          id: db_record.id,
          name: db_record.name,
          clips: clips
        )
      end
    end
  end
end
