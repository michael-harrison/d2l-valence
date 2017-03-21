module D2L
  module Valence
    # == Encrypt
    # Class encrypt and encode data for transmission in a URL
    class Encrypt
      # Encrypt and encode data with provided key
      #
      # @param [String] key the key to encrypt with
      # @param [String] data data to encrypt and encode
      def self.encode(key, data)
        remove_unwanted_chars Base64.encode64(compute_hash(key, data))
      end

      private
      def self.remove_unwanted_chars(string)
        string.gsub('=', '').gsub('+', '-').gsub('/', '_').strip
      end

      def self.compute_hash(key, data)
        OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), key, data)
      end
    end
  end
end
