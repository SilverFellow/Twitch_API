# frozen_string_literal: false

require_relative 'spec_helper.rb'

describe 'Tests Twitch library' do
  API_VER = 'api/v0.1'.freeze
  CASSETTE_FILE = 'web_api'.freeze

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Game information' do
    it 'HAPPY: should provide correct repo attributes' do
      get "#{API_VER}/repo/#{GAMENAME}"
      _(last_response.status).must_equal 200
      repo_data = JSON.parse last_response.body
      _(repo_data.size).must_be :>, 0
    end

    # it 'SAD: should raise exception on incorrect repo' do
    #   get "#{API_VER}/repo/#{GAMENAME}"
    #   _(last_response.status).must_equal 404
    #   body = JSON.parse last_response.body
    #   _(body.keys).must_include 'error'
    # end
  end

  describe 'Contributor information' do
  end
end
