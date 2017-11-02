# frozen_string_literal: true

module API
  module Repository
    # Repository for Clips
    class Clips
      def self.find_id(id)
        db_record = Database::ClipOrm.first(id: id)
        rebuild_entity(db_record)
      end

      def self.find_title(title)
        db_record = Database::ClipOrm.first(title: title)
        rebuild_entity(db_record)
      end

      def self.find_or_create(entity)
        find_title(entity.title) || create_from(entity)
      end

      def self.create_from(entity)
        db_clip = Database::ClipOrm.create(
          title: entity.title,
          url: entity.url,
          view: entity.view,
          source: entity.source,
          name: entity.name
        )

        rebuild_entity(db_collaborator)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Clip.new(
          id: db_record.id,
          title: db_record.title,
          url: db_record.url,
          view: db_record.view,
          source: db_record.source,
          name: db_record.name
        )
      end
    end
  end
end