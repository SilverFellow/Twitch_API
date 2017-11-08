# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

files = %w[clip_representer http_response_representer channel_representer game_representer]
files.each do |folder|
  require_relative "#{folder}.rb"
end
