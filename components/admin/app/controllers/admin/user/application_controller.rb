module Admin
  class User::ApplicationController < ApplicationController

    before_action :authenticate_user!
    # before_action :check_user

  end
end
