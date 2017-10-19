# frozen_string_literal: false
=begin
require 'minitest/autorun'
require 'minitest/rg'
require 'json'
require 'yaml'
require_relative '../lib/twitch_api.rb'
=end
require_relative 'spec_helper.rb'

describe 'Tests Twitch library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<Twitch_TOKEN>') { TOKEN }
    c.filter_sensitive_data('<Twitch_TOKEN_ESC>') { CGI.escape(TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end
=begin
  CHANNELNAME = 'shroud'.freeze
  GAMENAME = 'CSGO'.freeze
  CONFIG = YAML.safe_load(File.read('../config/secret.yml'))
  TOKEN = CONFIG['token']
  #CLIP = JSON.parse(File.read('fixtures/clip.json'))
  GAME = JSON.parse(File.read('../spec/fixtures/sample/game.json'))
=end
  # describe 'Clip information' do
    # it 'HAPPY: should provide correct clip attributes' do
    #   clip = Twitch::TwitchAPI.new(TOKEN).clip(CHANNELNAME)
    #   _(clip.size).must_equal CLIP['clips'].count
    # end

    # it 'SAD: should raise exception on incorrect channel_name' do
    #   proc do
    #     Twitch::TwitchAPI.new(TOKEN).clip('shroood')
    #   end.must_raise Twitch::TwitchAPI::Errors::NotFound
    # end

    # it 'SAD: should raise exception when unauthorized' do
    #   proc do
    #     Twitch::TwitchAPI.new('badtoken').clip(CHANNELNAME)
    #   end.must_raise Twitch::TwitchAPI::Errors::BadRequest
    # end
  # end

  describe 'Game information' do
    it 'HAPPY: should provide correct game attributes' do
      game = Twitch::TwitchAPI.new(TOKEN).game(GAMENAME)
      _(game.num).must_equal GAME['_total']
    end

    # it 'SAD: should raise exception on incorrect game_name' do
    #   proc do
    #     Twitch::TwitchAPI.new(TOKEN).game(GAMENAME)
    #   end.must_raise Twitch::TwitchAPI::Errors::NotFound
    # end

    it 'SAD: should raise exception when unauthorized' do
      proc do
        Twitch::TwitchAPI.new('badtoken').game(GAMENAME)
      end.must_raise Twitch::Errors::BadRequest
    end
  end
end
