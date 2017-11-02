# frozen_string_literal: true

folders = %w[database_repositories entities twitch_mappers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
