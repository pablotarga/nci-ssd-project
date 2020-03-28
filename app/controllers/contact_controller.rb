class ContactController < ApplicationController
  layout 'profile'

  def create
    name = contact_params[:name]
    email = contact_params[:email]
    message = contact_params[:message]
    ContactMailer.contact_email(name, email, message).deliver
    redirect_to contact_path, notice: 'Message sent'
  end

  def new
    @title = 'About NCI GameStore'
  end

  private
  def contact_params
    extract_params(:contact, permit: [:name, :email, :message])
  end

end
