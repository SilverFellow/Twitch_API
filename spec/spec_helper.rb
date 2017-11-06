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
# CONFIG = YAML.safe_load(File.read('config/secret.yml'))
# TOKEN = CONFIG['token']
# CLIP = JSON.parse(File.read('fixtures/clip.json'))
 GAME = JSON.parse(File.read('spec/fixtures/sample/game.json'))
 CHANNEL = JSON.parse(File.read('spec/fixtures/sample/channel.json'))
# CHANNNEL_CLIP = JSON.parse(File.read('spec/fixtures/sample/channel_clip.json'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze
# CASSETTE_FILE = 'twitch_api'.freeze

VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    api_token = app.config.token
    c.filter_sensitive_data('<Twitch_TOKEN>') { api_token }
    c.filter_sensitive_data('<Twitch_TOKEN_ESC>') { CGI.escape(api_token) }
end
