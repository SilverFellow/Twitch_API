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
      _(game.name).must_equal GAME['game']
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
end
