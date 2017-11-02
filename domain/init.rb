# frozen_string_literal: true

folders = %w[entities database_repositories twitch_mappers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
