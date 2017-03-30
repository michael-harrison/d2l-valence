module D2L
  module Valence
    # == Host
    # Class for the creation of URIs for communication with the D2L Valence API
    class Host
      attr_accessor :scheme, :host, :port

      # @param [Symbol] scheme URI scheme to be used (either :http or :https)
      # @param [String] host host name for D2L server (e.g. d2l.myinstitution.com)
      # @param [Integer] port specific port for transmission (optional)
      def initialize(scheme:, host:, port: nil)
        self.scheme = scheme
        self.host = host
        self.port = port
      end

      def host=(value)
        raise 'Host cannot be nil' if value.nil?
        @host = value
      end

      def scheme=(value)
        return if value.nil?
        value = value.downcase.to_sym if value.is_a? String
        raise "#{value} is an unsupported scheme. Please use either HTTP or HTTPS" unless supported_scheme? value
        @scheme = value
      end

      def to_uri(path: nil, query: nil)
        {
          http: URI::HTTP.build(host: host, port: port, path: path, query: query),
          https: URI::HTTPS.build(host: host, port: port, path: path, query: query)
        }[scheme]
      end

      private

      def supported_scheme?(value)
        [:http, :https].include? value
      end
    end
  end
end
