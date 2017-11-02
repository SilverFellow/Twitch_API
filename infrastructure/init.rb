# frozen_string_literal: false

folders = %w[twitch database/orm]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
