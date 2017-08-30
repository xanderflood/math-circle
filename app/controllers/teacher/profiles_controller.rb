class Teacher::ProfilesController < Teacher::BaseController
  before_action :set_parent
  before_action :set_parent_profile

  def show
  end

  def edit
  end

  def update
    if @parent_profile.update(parent_profile_params)
      redirect_to teacher_parents_path, notice: 'Parent profile was successfully updated.'
    else
      render :edit
    end
  end

  private
    def set_parent
      @parent = Parent.find(params[:parent_id])
    end

    def set_parent_profile
      @parent_profile = @parent.profile_or_new
      @profile = @parent_profile
    end

    # Only allow a trusted parameter "white list" through.
    def parent_profile_params
      params.fetch(:parent_profile, {}).permit(:parent_id,
              :first_name, :last_name, :email, :phone,
              :street1, :street2, :city, :state, :zip,
              :ec1_first_name, :ec1_last_name, :ec1_relation, :ec1_phone,
              :ec2_first_name, :ec2_last_name, :ec2_relation, :ec2_phone)
    end
end
