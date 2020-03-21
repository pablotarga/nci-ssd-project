class PagesController < ApplicationController
  layout 'profile'

  def landpage
    @title = "Hello World!"
    @products = Product.search(search_params).page(1)
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
    {}
  end

end
