class AdminController < ApplicationController
  before_action :require_admin

  layout 'admin'
end
