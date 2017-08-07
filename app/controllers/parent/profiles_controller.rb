class Parent::ProfilesController < ApplicationController
  before_action :set_parent_profile, only: [:show, :edit, :update, :destroy]

  # GET /parent_profiles/1
  def show
  end

  # GET /parent_profiles/new
  def new
    @parent_profile = ParentProfile.new
  end

  # GET /parent_profiles/1/edit
  def edit
  end

  # POST /parent_profiles
  def create
    @parent_profile = ParentProfile.new(parent_profile_params)

    if @parent_profile.save
      redirect_to @parent_profile, notice: 'Parent profile was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /parent_profiles/1
  def update
    if @parent_profile.update(parent_profile_params)
      redirect_to @parent_profile, notice: 'Parent profile was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /parent_profiles/1
  def destroy
    @parent_profile.destroy
    redirect_to parent_profiles_url, notice: 'Parent profile was successfully destroyed.'
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
        primary_contact: [:email, :phone])
    end
end
