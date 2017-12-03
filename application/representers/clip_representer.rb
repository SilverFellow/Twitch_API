# frozen_string_literal: true

module LoyalFan
  # Representer for Twitch clips information
  class ClipRepresenter < Roar::Decorator
    include Roar::JSON

    property :id
    property :title
    property :url
    property :view
    property :preview
    property :source
    property :name
  end
end
