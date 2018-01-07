class Teacher::ParentsController < Teacher::BaseController
  before_action :set_parent, only: [:show, :destroy]

  include Searchable
  search :parent_profiles, :profiles

  def index
    @profiles = ParentProfile.order(:first_name, :last_name)
                .paginate(page: params[:page], per_page: 50)
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
