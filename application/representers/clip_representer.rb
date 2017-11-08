# frozen_string_literal: true

module API
  class ClipRepresenter < Roar::Decorator
    include Roar::JSON

    property :id
    property :title
    property :url
    property :view
    property :source
    property :name
  end
end