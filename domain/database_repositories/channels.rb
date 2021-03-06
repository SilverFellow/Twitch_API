# frozen_string_literal: true

module LoyalFan
  module Repository
    # Repository for Channels
    class Channels
      def self.find_id(id)
        db_record = Database::ChannelOrm.first(id: id)
        rebuild_entity(db_record)
      end

      def self.find_url(name)
        url = 'https://go.twitch.tv/' + name
        db_record = Database::ChannelOrm.first(url: url)
        rebuild_entity(db_record)
      end

      def self.db_exist?(url)
        Database::ChannelOrm.first(url: url) != nil
      end

      def self.update_or_create(entity)
        db_exist?(entity.url) ? update(entity) : create_from(entity)
      end

      def self.create_from(entity)
        db_channel = Database::ChannelOrm.create(
          url: entity.url,
          name: entity.name,
          user_id: entity.user_id,
          live: entity.live,
          title: entity.title,
          game: entity.game,
          viewer: entity.viewer,
          logo: entity.logo
        )

        entity.clips.each { |clip| Clips.update_or_create(db_channel, clip) }

        rebuild_entity(db_channel)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        clips = db_record.clips.map do |clip|
          Clips.rebuild_entity(clip)
        end

        Entity::Channel.new(
          id: db_record.id,
          url: db_record.url,
          name: db_record.name,
          user_id: db_record.user_id,
          live: db_record.live,
          title: db_record.title,
          game: db_record.game,
          viewer: db_record.viewer,
          logo: db_record.logo,
          clips: clips
        )
      end

      def self.update(entity)
        Database::ChannelOrm.first(url: entity.url).update(
          live: entity.live,
          title: entity.title,
          viewer: entity.viewer
        )
        Database::ChannelOrm.first(url: entity.url).update(game: entity.game) if entity.live

        db_channel = Database::ChannelOrm.first(url: entity.url)
        entity.clips.each { |clip| Clips.update_or_create(db_channel, clip) }

        rebuild_entity(db_channel)
      end
    end
  end
end
