module D2L
  module Valence
    # == TimestampError
    # This class is aimed at parsing and providing diagnostics for time based issues
    # between the D2L Brightspace Server and Ruby Client
    class TimestampError
      # @param [String] D2L Brightspace Server Error Message
      def initialize(error_message)
        @error_message = error_message
      end

      # @return [Integer] difference in D2L Server timestamp in milliseconds
      def server_skew
        return 0 if server_timestamp.nil?

        @server_skew ||= server_timestamp - now_in_ms
      end

      # @return [Integer] true if our timestamp is out of range with the D2L Server
      def timestamp_out_of_range?
        server_timestamp != nil
      end

      private

      # @return [Integer] D2L Server timestamp
      def server_timestamp
        @server_timestamp ||= parse_timestamp
      end

      # @return [Integer] local timestamp now in milliseconds
      def now_in_ms
        (Time.now.to_f * 1000).to_i
      end

      def parse_timestamp
        match = Regexp.new(/Timestamp out of range\s*(\d+)/).match(@error_message)
        match[1].to_i * 1000 if !match.nil? && match.length >= 2
      end
    end
  end
end
