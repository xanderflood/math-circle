class Parent::ProfilesController < ApplicationController
  before_action :set_parent_profile, only: [:show, :update]

  # GET /parent_profiles/1
  def show
  end

  # POST /parent_profiles
  def create
    @parent_profile = ParentProfile.new(parent_profile_params)

    if @parent_profile.save
      redirect_to parent_home_path, notice: 'Parent profile was successfully created.'
    else
      render :show
    end
  end

  # PATCH/PUT /parent_profiles/1
  def update
    if @parent_profile.update(parent_profile_params)
      redirect_to parent_home_path, notice: 'Parent profile was successfully updated.'
    else
      render :show
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parent_profile
      @parent_profile = current_parent.profile_or_new
    end

    # Only allow a trusted parameter "white list" through.
    def parent_profile_params
      params.fetch(:parent_profile, {}).permit(
        :parent_id,
        :first_name,
        :last_name,
        primary_contact_attributes:     [:email, :phone, :street1, :street2, :city, :state, :zip],
        emergency_contact_attributes:   [:email, :phone, :street1, :street2, :city, :state, :zip],
        emergency_contact_2_attributes: [:email, :phone, :street1, :street2, :city, :state, :zip])
    end
end
