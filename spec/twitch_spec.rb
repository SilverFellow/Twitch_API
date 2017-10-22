# frozen_string_literal: false

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

  describe 'Game information' do
    it 'HAPPY: should provide correct game attributes' do
      game = Twitch::TwitchAPI.new(TOKEN).game(GAMENAME)
      _(game.num).must_equal GAME['_total']
      _(game.name).must_equal GAME['streams'][0]['game']
    end
    # it 'SAD: should raise exception on incorrect game_name' do
    #   proc do
    #    Twitch::TwitchAPI.new(TOKEN).game('IsntFun')
    #   end.must_raise Twitch::Errors::NotFound
    # end
    it 'SAD: should raise exception when unauthorized' do
      proc do
        Twitch::TwitchAPI.new('badtoken').game(GAMENAME)
      end.must_raise Twitch::Errors::BadRequest
    end
  end

  describe 'Channel Information' do
    before do
      @channel = Twitch::TwitchAPI.new(TOKEN).channel(CHANNELNAME)
    end

    it 'HAPPY: is channel live?' do
      _(@channel.live?).must_equal true
    end

    it 'HAPPY: channels title should be correct' do
      _(@channel.title).wont_be_nil
      _(@channel.title).must_equal CHANNEL['stream']['channel']['status']
    end

    it 'HAPPY: clips should be three' do
      _(@channel.clips.count).must_equal 3
    end
  end

  describe 'Clip Information' do
    before do
      @channel_clip = Twitch::TwitchAPI.new(TOKEN).clip('channel', CHANNELNAME)
      @game_clip = Twitch::TwitchAPI.new(TOKEN).clip('game', GAMENAME)
    end

    it 'HAPPY: channel_clips should be three' do
      _(@channel_clip.top_clips.count).must_equal 3
    end

    it 'HAPPY: game_clips should be three' do
      _(@game_clip.top_clips.count).must_equal 3
    end
  end
end
