# frozen_string_literal: false

require 'simplecov'
SimpleCov.start
require 'json'
require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../lib/twitch_api.rb'

CHANNELNAME = 'toyzttv'.freeze
GAMENAME = 'IRL'.freeze
CONFIG = YAML.safe_load(File.read('config/secret.yml'))
TOKEN = CONFIG['token']
# CLIP = JSON.parse(File.read('fixtures/clip.json'))
GAME = JSON.parse(File.read('spec/fixtures/sample/game.json'))
CHANNEL = JSON.parse(File.read('spec/fixtures/sample/channel.json'))
CHANNNEL_CLIP = JSON.parse(File.read('spec/fixtures/sample/channel_clip.json'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze
CASSETTE_FILE = 'twitch_api'.freeze
