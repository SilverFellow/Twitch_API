# frozen_string_literal: true

files = %w[channels clips games for]
files.each do |folder|
  require_relative "#{folder}.rb"
end
