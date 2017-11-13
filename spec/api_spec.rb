# frozen_string_literal: false

require_relative 'spec_helper.rb'

describe 'Tests Twitch library' do
  API_VER = 'api/v0.1'.freeze
  CASSETTE_FILE = 'web_api'.freeze
  # GAME = JSON.parse(File.read('spec/fixtures/sample/game.json'))
  # CHANNEL = JSON.parse(File.read('spec/fixtures/sample/channel.json'))

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Game information' do
    before do
      app.DB[:games_clips].delete
      app.DB[:channels_clips].delete
      app.DB[:games_channels].delete
      app.DB[:clips].delete
      app.DB[:channels].delete
      app.DB[:games].delete
    end

    describe "POSTing to create game entities from Twitch" do
      it 'HAPPY: should provide correct game connection' do
        post "#{API_VER}/game/#{GAMENAME}"
        _(last_response.status).must_equal 201
        _(last_response.header['Location'].size).must_be :>, 0
        game_data = JSON.parse last_response.body
        _(game_data.size).must_be :>, 0
      end

      it 'SAD: should raise exception on incorrect game' do
        post "#{API_VER}/game/boring_game"
        _(last_response.status).must_equal 400
      end
    end

    describe "GETing database entities" do
      before do
        post "#{API_VER}/game/#{GAMENAME}"
      end

      it 'HAPPY: should find stored game' do
        get "#{API_VER}/game/#{GAMENAME}"
        _(last_response.status).must_equal 200
        game_data = JSON.parse last_response.body
        _(game_data.size).must_be :>, 0
      end

      it 'SAD: should report error if no database game entity found' do
        get "#{API_VER}/game/boring_game"
        _(last_response.status).must_equal 404
      end
    end
  end

  describe 'Channel information' do
    before do
      # Rake::Task['db:reset'].invoke
      app.DB[:games_clips].delete
      app.DB[:channels_clips].delete
      app.DB[:games_channels].delete
      app.DB[:clips].delete
      app.DB[:channels].delete
      app.DB[:games].delete
    end

    after do
      Rake::Task['db:reset'].invoke
    end

    describe "POSTing to create channel entities from Twitch" do
      it 'HAPPY: should provide correct channel connection' do
        post "#{API_VER}/channel/#{CHANNELNAME}"
        _(last_response.status).must_equal 201
        _(last_response.header['Location'].size).must_be :>, 0
        channel_data = JSON.parse last_response.body
        _(channel_data.size).must_be :>, 0
      end

      it 'SAD: should raise exception on incorrect channel' do
        post "#{API_VER}/channel/khekhkgkskg"
        _(last_response.status).must_equal 400
      end
    end

    describe "GETing database entities" do
      before do
        post "#{API_VER}/channel/#{CHANNELNAME}"
      end

      it 'HAPPY: should find stored channel' do
        # post "#{API_VER}/channel/#{CHANNELNAME}"
        get "#{API_VER}/channel/#{CHANNELNAME}"
        _(last_response.status).must_equal 200
        channel_data = JSON.parse last_response.body
        _(channel_data.size).must_be :>, 0
      end

      it 'SAD: should report error if no database channel entity found' do
        get "#{API_VER}/channel/noscuhchannella"
        _(last_response.status).must_equal 404
      end
    end
  end
end
