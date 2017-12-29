# frozen_string_literal: true

module LoyalFan
  class Api < Roda
    # Represent HTTP response for result
    # Parameters:
    #   - result: Result object with #message to represent
    #   - success_representer: representer class if result is success
    #                          #to_json called if result is failure
    #   - (optional) block to execute before success representation
    # Returns: Json representation of success/failure message
    def represent_response(result, success_representer)
      http_response = HttpResponseRepresenter.new(result.value)
      response.status = http_response.http_code
      message = result.value.message
      # we do this because of parallel worker .
      message = message[:response] if message.is_a?(Hash)
      if result.success?
        yield if block_given?
        success_representer.new(message).to_json
      else
        http_response.to_json
      end
    end
  end
end
