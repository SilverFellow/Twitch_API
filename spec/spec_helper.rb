# frozen_string_literal: false

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'json'
require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative 'test_load_all'

load 'Rakefile'
Rake::Task['db:reset'].invoke

CHANNELNAME = 'godjj'.freeze
GAMENAME = 'H1Z1'.freeze

GAME = JSON.parse(File.read('spec/fixtures/sample/game.json'))
CHANNEL = JSON.parse(File.read('spec/fixtures/sample/channel.json'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze

VCR.configure do |c|
c.cassette_library_dir = CASSETTES_FOLDER
c.hook_into :webmock

api_token = app.config.TWITCH_TOKEN
c.filter_sensitive_data('<TWITCH_TOKEN>') { api_token }
c.filter_sensitive_data('<TWITCH_TOKEN_ESC>') { CGI.escape(api_token) }
end
