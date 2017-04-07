module D2L
  module Valence
    # == AuthTokens
    # Class to generate authentication tokens for D2L Valance API calls
    class AuthTokens
      APP_ID_PARAM = 'x_a'.freeze
      USER_ID_PARAM = 'x_b'.freeze
      SIGNATURE_BY_APP_KEY_PARAM = 'x_c'.freeze
      SIGNATURE_BY_USER_KEY_PARAM = 'x_d'.freeze
      TIMESTAMP_PARAM = 'x_t'.freeze

      # @param [D2L::Valence::Request] request the authenticated request that the auth tokens are for
      def initialize(request:)
        @call = request
        @user_context = @call.user_context
        @app_context = @user_context.app_context
      end

      # Generates the auth tokens as a Hash for inclusion in the final URI query string
      # @return [Hash] tokens for authenticated call
      def generate
        @tokens = {}
        add_app_tokens
        add_user_tokens
        add_timestamp_token
        @tokens
      end

      # Generates a timestamp with time skew between server and client taken into consideration
      #
      # @return [Integer] Server skew adjusted timestamp in seconds
      def adjusted_timestamp
        @adjusted_timestamp ||= Time.now.to_f.to_i + @user_context.server_skew
      end

      private

      def add_app_tokens
        @tokens[APP_ID_PARAM] = @app_context.app_id
        @tokens[SIGNATURE_BY_APP_KEY_PARAM] = Encrypt.generate_from(@app_context.app_key, signature)
      end

      def add_user_tokens
        return if @user_context.user_id.nil?

        @tokens[USER_ID_PARAM] = @user_context.user_id
        @tokens[SIGNATURE_BY_USER_KEY_PARAM] = Encrypt.generate_from(@user_context.user_key, signature)
      end

      def add_timestamp_token
        @tokens[TIMESTAMP_PARAM] = adjusted_timestamp
      end

      # Generates a signature requite by the D2L Valence API
      def signature
        @signature ||= "#{@call.http_method}&#{CGI.unescape(@call.path).downcase}&#{adjusted_timestamp}"
      end
    end
  end
end
