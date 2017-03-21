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
        encode64(sign(key,data))
      end

      private
      def self.sign(key, data)
        OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), key, data)
      end

      def self.encode64(digest)
        Base64.urlsafe_encode64(digest, padding: false).strip
      rescue
        old_encode64 digest
      end

      # support for older versions of ruby
      def self.old_encode64(digest)
        remove_unwanted_chars Base64.encode64(digest).strip
      end

      def self.remove_unwanted_chars(string)
        string.gsub('=', '').gsub('+', '-').gsub('/', '_').strip
      end
    end
  end
end
