# frozen_string_literal: false

require_relative 'spec_helper.rb'
require 'econfig'

describe 'Tests Twitch library' do
  extend Econfig::Shortcut
  Econfig.env = 'development'
  Econfig.root = '.'

  TOKEN = config.token
  # CLIP = JSON.parse(File.read('fixtures/clip.json'))
  # GAME = JSON.parse(File.read('spec/fixtures/sample/game.json'))
  # CHANNEL = JSON.parse(File.read('spec/fixtures/sample/channel.json'))
  # CHANNNEL_CLIP = JSON.parse(File.read('spec/fixtures/sample/channel_clip.json'))
  CASSETTE_FILE = 'twitch_api'.freeze

  # VCR.configure do |c|
  #   c.cassette_library_dir = CASSETTES_FOLDER
  #   c.hook_into :webmock

  #   c.filter_sensitive_data('<Twitch_TOKEN>') { TOKEN }
  #   c.filter_sensitive_data('<Twitch_TOKEN_ESC>') { CGI.escape(TOKEN) }
  # end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Game information' do
    it 'HAPPY: should provide correct game attributes' do
      api = API::Twitch::TwitchGateway.new(TOKEN)
      game_mapper = API::Twitch::GameMapper.new(api)
      game = game_mapper.load(GAMENAME)
    # _(game.number).must_equal GAME['_total']
      _(game.official_name).must_equal GAME['streams'][0]['game']
    end
    # it 'SAD: should raise exception on incorrect game_name' do
    #   proc do
    #    Twitch::TwitchAPI.new(TOKEN).game('IsntFun')
    #   end.must_raise Twitch::Errors::NotFound
    # end
    it 'SAD: should raise exception when unauthorized' do
      proc do
        bad_api = API::Twitch::TwitchGateway.new('badtoken')
        game_mapper = API::Twitch::GameMapper.new(bad_api)
        game = game_mapper.load(GAMENAME)
      end.must_raise API::Twitch::TwitchGateway::Errors::BadRequest
    end
  end

  describe 'Channel Information' do
    before do
      api = API::Twitch::TwitchGateway.new(TOKEN)
      channel_mapper = API::Twitch::ChannelMapper.new(api)
      @channel = channel_mapper.load(CHANNELNAME)
    end

    it 'HAPPY: is channel live?' do
      _(@channel.live).must_equal true
    end

    it 'HAPPY: channels title should be correct' do
      _(@channel.title).wont_be_nil
      _(@channel.title).must_equal CHANNEL['stream']['channel']['status']
    end

    it 'HAPPY: clips should be ten' do
      _(@channel.clips.count).must_equal 10
    end
  end

  describe 'Clip Information' do
    before do
      api = API::Twitch::TwitchGateway.new(TOKEN)
      clip_mapper = API::Twitch::ClipMapper.new(api)
      @channel_clip = clip_mapper.load('channel', CHANNELNAME)
      @game_clip = clip_mapper.load('game', GAMENAME)
    end

    it 'HAPPY: channel_clips should be ten' do
      _(@channel_clip.count).must_equal 10
    end

    it 'HAPPY: game_clips should be ten' do
      _(@game_clip.count).must_equal 10
    end
  end
end
