# frozen_string_literal: true
require 'concurrent'

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

      # def self.find_userid(user_id)
      #   db_record = Database::ChannelOrm.first(user_id: user_id)
      #   rebuild_entity(db_record)
      # end

      def self.update_or_create(entity)
        db_exist?(entity.url) ? update(entity) : create_from(entity)
      end

      # def self.update_or_create2(entity)
      #   db_exist?(entity.url) ? update(entity) : con_create_from(entity)
      # end

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

        entity.clips.each do |clip|
          stored_clip = Clips.find_or_create(clip)
          clip = Database::ClipOrm.first(id: stored_clip.id)
          db_channel.add_clip(clip)
        end

        rebuild_entity(db_channel)
      end

      # def self.con_create_from(entity)
      #   db_channel = Database::ChannelOrm.create(
      #     url: entity.url,
      #     name: entity.name,
      #     user_id: entity.user_id,
      #     live: entity.live,
      #     title: entity.title,
      #     game: entity.game,
      #     viewer: entity.viewer,
      #     logo: entity.logo
      #   )

      #   entity.clips.map do |clip|
      #     Concurrent::Promise
      #       .new { Clips.find_or_create(clip) }
      #       .then { |ret| Database::ClipOrm.first(id: ret.id) }
      #       .then { |ret| db_channel.add_clip(ret) }
      #   end.map(&:execute)

      #   rebuild_entity(db_channel)
      # end

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
        Database::ChannelOrm.where(url: entity.url).update(
          live: entity.live,
          title: entity.title,
          game: entity.game,
          viewer: entity.viewer
        )
        entity
      end
    end
  end
end
