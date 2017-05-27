require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Census < OmniAuth::Strategies::OAuth2
      include OmniAuth::Strategy

      @@prod_site = "https://turing-census.herokuapp.com"
      @@stag_site = "http://census-app-staging.herokuapp.com"
      @@census_site = ENV['RACK_ENV'] == 'production' ? @@prod_site : @@stag_site

      option :client_options, {
               # site: "https://turing-census.herokuapp.com",
               site: "http://census-app-staging.herokuapp.com",
               # site: @@census_site,
               authorize_url: "/oauth/authorize",
               token_url: "/oauth/token"
             }

      def request_phase
        super
      end

      def callback_url
        full_host + script_name + callback_path
      end

      info do
        raw_info.merge("token" => access_token.token)
      end

      uid { raw_info["id"] }

      def raw_info
        @raw_info ||=
          access_token.get('/api/v1/user_credentials').parsed
      end
    end
  end
end
