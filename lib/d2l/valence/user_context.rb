module D2L
  module Valence
    # == UserContext
    # Instances of this class are used to make D2L Valance API calls with the current user credentials
    class UserContext
      attr_reader :app_context,
                  :user_id,
                  :user_key

      attr_accessor :server_skew # in seconds

      # @param [D2L::Valence::AppContext] app_context
      # @param [String] user_id User ID returned from the D2L Server in authentication process
      # @param [String] user_key User Key returned the D2L Server in authentication process
      def initialize(app_context:, user_id:, user_key:)
        @app_context = app_context
        @user_id = user_id
        @user_key = user_key
        @server_skew = 0
      end

      # Calls a API method on the Valance API
      #
      # == API routes
      # When providing the route you can also provide the variables for the parameters in the route. For example, the
      # following route will require `{org_unit_id: 1, group_category_id: 23}` for `route_params`:
      #
      # /d2l/api/lp/:version/:org_unit_id/groupcategories/:group_category_id
      #
      # The `to_uri` method will place the parameters in the route to make the final path.  For example:
      #
      # /d2l/api/lp/1.0/1/groupcategories/23
      #
      # There are known parameters such as `:version` which is provided when you create your initial AppContext
      # instance.  This will mean that some routes will require no parameters for example:
      #
      # /d2l/api/lp/:version/users/whoami
      #
      # which becomes
      # /d2l/api/lp/1.0/users/whoami
      #
      # @param [String] http_method the HTTP Method for the call (i.e. PUT, GET, POST, DELETE)
      # @param [String] route the API method route (e.g. /d2l/api/lp/:version/users/whoami)
      # @param [Hash] route_params the parameters for the API method route (option)
      # @param [Hash] query_params the query parameters for the method call
      # @return [D2L::Valence::RequestResult] returns a request
      def api_call(http_method:, route:, route_params:, query_params:)
        D2L::Valence::Request.new(
          user_context: self,
          http_method: http_method,
          route: route,
          route_params: route_params,
          query_params: query_params
        ).execute
      end
    end
  end
end
