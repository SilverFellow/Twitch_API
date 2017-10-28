# frozen_string_literal: false

require_relative 'spec_helper.rb'

describe 'Tests Twitch library' do
  API_VER = 'api'.freeze
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
    it 'HAPPY: should provide correct game connection' do
      get "#{API_VER}/game/#{GAMENAME}"
      _(last_response.status).must_equal 200
      game_data = JSON.parse last_response.body
      _(game_data.size).must_be :>, 0
    end

    it 'HAPPY: should provide correct game attributes' do
      get "#{API_VER}/game/#{GAMENAME}"
      game_data = JSON.parse last_response.body
      _(game_data['name']).must_equal GAMENAME
      _(game_data['number']).must_equal GAME['_total']
    end

    it 'HAPPY: should provide correct amount of game streamers and clips' do
      get "#{API_VER}/game/#{GAMENAME}"
      game_data = JSON.parse last_response.body
      _(game_data['streamers'].count).must_equal 3
      _(game_data['clips'].count).must_equal 10
    end

    it 'SAD: should raise exception on incorrect game' do
      get "#{API_VER}/game/boring_game"
      _(last_response.status).must_equal 404
      game_data = JSON.parse last_response.body
       _(game_data.keys).must_include 'error'
    end
  end

  describe 'Channel information' do
    it 'HAPPY: should provide correct channel connection' do
      get "#{API_VER}/channel/#{CHANNELNAME}"
      _(last_response.status).must_equal 200
      game_data = JSON.parse last_response.body
      _(game_data.size).must_be :>, 0
    end

    it 'HAPPY: should provide correct channel attributes' do
      get "#{API_VER}/channel/#{CHANNELNAME}"
      channel_data = JSON.parse last_response.body
      _(channel_data['live']).must_equal true
      _(channel_data['title']).must_equal CHANNEL['stream']['channel']['status']
    end

    it 'HAPPY: should provide correct amount of channel clips' do
      get "#{API_VER}/channel/#{CHANNELNAME}"
      channel_data = JSON.parse last_response.body
      _(channel_data['clips'].count).must_equal 10
    end

    it 'SAD: should raise exception on incorrect channel' do
      get "#{API_VER}/channel/khekhkgkskg"
      _(last_response.status).must_equal 404
      game_data = JSON.parse last_response.body
       _(game_data.keys).must_include 'error'
    end
  end
end
