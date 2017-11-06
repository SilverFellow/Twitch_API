# frozen_string_literal: true

module API
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

      def self.find_userid(user_id)
        db_record = Database::ChannelOrm.first(user_id: user_id)
        rebuild_entity(db_record)
      end

      def self.find_or_create(entity)
        find_url(entity.url) || create_from(entity)
      end

      def self.create_from(entity)
        db_channel = Database::ChannelOrm.create(
          url: entity.url,
          user_id: entity.user_id,
          live: entity.live,
          title: entity.title,
          game: entity.game,
          viewer: entity.viewer
        )

        entity.clips.each do |clip|
          stored_clip = Clips.find_or_create(clip)
          clip = Database::ClipOrm.first(id: stored_clip.id)
          db_channel.add_clip(clip)
        end

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
          user_id: db_record.user_id,
          live: db_record.live,
          title: db_record.title,
          game: db_record.game,
          viewer: db_record.viewer,
          clips: clips
        )
      end
    end
  end
end
