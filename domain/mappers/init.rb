# frozen_string_literal: true

folders = %w[twitch_mappers]

folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
