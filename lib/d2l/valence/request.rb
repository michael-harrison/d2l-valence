module D2L
  module Valence
    # == Request
    # Class for authenticated calls to the D2L Valence API
    class Request
      attr_reader :user_context,
                  :http_method,
                  :response

      #
      # == API routes
      # See D2L::Valence::UserContext.api_call for details on creating routes and route_params
      #
      # @param [D2L::Valance::UserContext] user_context the user context created after authentication
      # @param [String] http_method the HTTP Method for the call (i.e. PUT, GET, POST, DELETE)
      # @param [String] route the API method route (e.g. /d2l/api/lp/:version/users/whoami)
      # @param [Hash] route_params the parameters for the API method route (option)
      # @param [Hash] query_params the query parameters for the method call
      def initialize(user_context:, http_method:, route:, route_params: {}, query_params: {})
        @user_context = user_context
        @app_context = user_context.app_context
        @http_method = http_method.upcase
        @route = route
        @route_params = route_params
        @query_params = query_params

        raise "HTTP Method #{@http_method} is unsupported" unless %w(GET PUT POST DELETE).include? @http_method
      end

      # Generates an authenticated URI for a the Valence API method
      #
      # @return [URI::Generic] URI for the authenticated method call
      def authenticated_uri
        @app_context.brightspace_host.to_uri(
          path: path,
          query: query
        )
      end

      # Sends the authenticated call on the Valence API
      #
      # @return [D2L::Valence::Response] URI for the authenticated methof call
      def execute
        raise "HTTP Method #{@http_method} is not implemented" unless respond_to? @http_method.downcase

        @response = send(@http_method.downcase)
        @user_context.server_skew = @response.server_skew
        @response
      end

      # Generates the final path for the authenticated call
      #
      # @return [String] path for the authenticated call
      def path
        return @path unless @path.nil?

        substitute_keys_with(known_params)
        substitute_keys_with(@route_params)
        @path = @route
      end

      def get
        Response.new RestClient.get(authenticated_uri.to_s)
      rescue RestClient::Exception => e
        Response.new e.response
      end

      def post
        Response.new RestClient.post(authenticated_uri.to_s, @query_params.to_json, content_type: :json)
      rescue RestClient::Exception => e
        Response.new e.response
      end

      private

      def substitute_keys_with(params)
        params.each { |param, value| @route.gsub!(":#{param}", value.to_s) }
      end

      def known_params
        {
          version: @user_context.app_context.api_version
        }
      end

      def query
        return to_query_params(authenticated_tokens) unless @http_method == 'GET'

        to_query_params@query_params.merge(authenticated_tokens)
      end

      def to_query_params(hash)
        hash.map { |k, v| "#{k}=#{v}" }.join('&')
      end

      def authenticated_tokens
        D2L::Valence::AuthTokens.new(request: self).generate
      end
    end
  end
end
