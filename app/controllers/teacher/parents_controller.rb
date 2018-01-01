class Teacher::ParentsController < Teacher::BaseController
  before_action :set_parent, only: [:show, :destroy]

  def index
    @profiles = ParentProfile.order(:first_name, :last_name)
                .paginate(page: params[:page], per_page: 50)
  end

  def search
    @profiles = if params[:search][:id]
      p = ParentProfile.find_by_id(params[:search][:id].to_i)

      [p].compact
    else
      ParentProfile.where("first_name ILIKE ?", "%#{params[:search][:first_name]}%")
      .where("last_name ILIKE ?",  "%#{params[:search][:last_name]}%")
      .where("email ILIKE ?",  "%#{params[:search][:email]}%")
      .where("id ILIKE ?",  "%#{params[:search][:id]}%")
    end
  end

  def destroy
    @parent.destroy
    redirect_to teacher_parents_url, notice: 'Parent was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parent
      @parent = Parent.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def parent_params
      params.fetch(:parent, {})
    end
end
