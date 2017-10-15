# frozen_string_literal: false

require 'minitest/autorun'
require 'minitest/rg'
require 'json'
require 'yaml'
require_relative '../lib/twitch_api.rb'

describe 'Tests Twitch library' do
  CHANNELNAME = 'shroud'.freeze
  GAMENAME = 'SOS'.freeze
  CONFIG = YAML.safe_load(File.read('../config/secret.yml'))
  TOKEN = CONFIG['token']
  CLIP = JSON.parse(File.read('fixtures/clip.json'))
  GAME = JSON.parse(File.read('fixtures/game.json'))

  describe 'Clip information' do
    it 'HAPPY: should provide correct clip attributes' do
      clip = Twitch::TwitchAPI.new(TOKEN).clip(CHANNELNAME)
      _(clip.size).must_equal CLIP['clips'].count
    end

    # it 'SAD: should raise exception on incorrect channel_name' do
    #   proc do
    #     Twitch::TwitchAPI.new(TOKEN).clip('shroood')
    #   end.must_raise Twitch::TwitchAPI::Errors::NotFound
    # end

    it 'SAD: should raise exception when unauthorized' do
      proc do
        Twitch::TwitchAPI.new('badtoken').clip(CHANNELNAME)
      end.must_raise Twitch::TwitchAPI::Errors::BadRequest
    end
  end

  describe 'Game information' do
    it 'HAPPY: should provide correct game attributes' do
      game = Twitch::TwitchAPI.new(TOKEN).game(GAMENAME)
      _(game.size).must_equal GAME['_total']
    end

    # it 'SAD: should raise exception on incorrect game_name' do
    #   proc do
    #     Twitch::TwitchAPI.new(TOKEN).game(GAMENAME)
    #   end.must_raise Twitch::TwitchAPI::Errors::NotFound
    # end

    it 'SAD: should raise exception when unauthorized' do
      proc do
        Twitch::TwitchAPI.new('badtoken').game(GAMENAME)
      end.must_raise Twitch::TwitchAPI::Errors::BadRequest
    end
  end
end
