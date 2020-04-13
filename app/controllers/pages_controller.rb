class PagesController < ApplicationController
  def landpage
    @products = Product.page(params[:page].presence || 1).per(20).search(search_params)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def about
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
