module D2L
  module Valence
    # == Response
    # Class for interpreting the response from the D2L Valence API
    class Response
      attr_reader :http_response

      # @param [RestClient::Response] http_response response from a request against the Valance API
      def initialize(http_response)
        @http_response = http_response
        @server_skew = 0
      end

      # @return [String] Plain text response from the D2L server
      def body
        @http_response.body
      end

      # Generates a hash based on a valid JSON response from the D2L server.  If the provided response is not in a
      # value JSON format then an empty hash is returned
      #
      # @return [Hash] hash based on JSON body
      def to_hash
        @to_hash ||= JSON.parse(body)
      rescue
        @to_hash = {}
      end

      # @return [Symbol] the interpreted code for the Valance API response
      def code
        interpret_forbidden || http_code
      end

      # @return [Integer] the difference in D2L Valance API Server time and local time
      def server_skew
        return 0 unless timestamp_error.timestamp_out_of_range?

        @server_skew = timestamp_error.server_skew
      end

      private

      def http_code
        "HTTP_#{@http_response.code}".to_sym
      end

      def interpret_forbidden
        return unless @http_response.code == 403

        invalid_timestamp || invalid_token
      end

      def invalid_timestamp
        :INVALID_TIMESTAMP if timestamp_error.timestamp_out_of_range?
      end

      def timestamp_error
        @timestamp_error ||= TimestampError.new(@http_response.body)
      end

      def invalid_token
        :INVALID_TOKEN if @http_response.body.include? 'invalid token'
      end
    end
  end
end
