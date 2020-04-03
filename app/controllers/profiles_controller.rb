class ProfilesController < ApplicationController
  before_action :require_person

  def welcome
  end

  def show
  end

  def update
    update_params
    if current_user.update_attributes(update_params)
      flash[:notice] = t('notices.saved_with_success')
    else
      flash[:alert] = current_user.errors.full_messages
    end
    render 'show'
  end

  private

  def update_params
    _params = extract_params :person, permit: [:title, :name, :email, :password, :locale]
    _params.delete :password unless _params[:password].present?
    _params
  end


end
