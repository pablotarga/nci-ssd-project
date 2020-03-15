class PagesController < ApplicationController
  layout 'profile'

  def landpage
    @title = "Hello World!"
    # render 'show'
  end


  # def index -> list all item
  # def show -> show specific item
  # def edit -> edit form
  # def new -> creaet form
  # def create -> create action
  # def update -> update action
  # def destroy -> remove from db

end
