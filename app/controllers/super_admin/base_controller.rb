class SuperAdmin::BaseController < ApplicationController
  before_action :authenticate_super_admin!

  layout 'super_admin'

  def pundit_user
    current_super_admin
  end
end
