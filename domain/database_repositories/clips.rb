# frozen_string_literal: true

module LoyalFan
  module Repository
    # Repository for Clips
    class Clips
      def self.find_id(id)
        db_record = Database::ClipOrm.first(id: id)
        rebuild_entity(db_record)
      end

      def self.find_url(url)
        db_record = Database::ClipOrm.first(url: url)
        rebuild_entity(db_record)
      end

      def self.db_exist?(url)
        Database::ClipOrm.first(url: url) != nil
      end

      def self.find_or_create(entity)
        find_url(entity.url) || create_from(entity)
      end

      def self.update_or_create(table, entity)
        db_exist?(entity.url) ? update(entity) : create_from(table, entity)
      end

      def self.create_from(table, entity)
        db_clip = Database::ClipOrm.create(
          title: entity.title,
          url: entity.url,
          view: entity.view,
          preview: entity.preview,
          source: entity.source,
          name: entity.name
        )
        table.add_clip(db_clip)

        # rebuild_entity(db_clip)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Clip.new(
          id: db_record.id,
          title: db_record.title,
          url: db_record.url,
          view: db_record.view,
          preview: db_record.preview,
          source: db_record.source,
          name: db_record.name
        )
      end

      def self.update(entity)
        db_clip = Database::ClipOrm.first(url: entity.url).update(
          title: entity.title,
          view: entity.view,
          preview: entity.preview
        )
        db_clip ? rebuild_entity(db_clip) : entity
      end
    end
  end
end
