class PagesController < ApplicationController
  layout 'profile'

  def landpage
    @title = "Hello World!"
    @products = Product.page(params[:page].presence || 1).per(20).search(search_params)
  end

  def about
    @title = "About NCI GameStore"
  end

  # def index -> list all item
  # def show -> show specific item
  # def edit -> edit form
  # def new -> creaet form
  # def create -> create action
  # def update -> update action
  # def destroy -> remove from db

  private

  def search_params
    params[:q]
  end

end
