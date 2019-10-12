module Frontend
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    include Shared::Controller::Layout
    before_action :get_conferences

    private
      def get_conferences
        @conferences = Product::Conference.all
      end
  end
end
