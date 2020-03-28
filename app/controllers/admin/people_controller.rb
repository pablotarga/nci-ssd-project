class Admin::PeopleController < AdminController
  before_action :person_required!, only: [:edit, :update]


  def index
    @people = Person.all
  end

  def edit
  end

  def update
    if person.update_attributes(update_params)
      redirect_to admin_people_path, notice: t('notices.saved_with_success')
    else
      flash[:alert] = person.errors.full_message
      render 'edit'
    end
  end

  private

  def update_params
    _params = extract_params :person, permit: [:name, :email, :password, :locale, :admin]
    _params.delete :password unless _params[:password].present?
    _params
  end


  def person_required!
    redirect_to(admin_people_path, alert: t('error.not_found')) unless person.present?
  end

  def person
    @person ||= Person.where(id: params[:id]).first
  end
end
