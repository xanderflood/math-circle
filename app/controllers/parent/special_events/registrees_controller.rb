class Parent::SpecialEvents::RegistreesController < Parent::BaseController
  before_action :set_special_registree, only: [:update, :destroy]

  def create
    @special_registree = SpecialRegistree.new(special_registree_params)

    if @special_registree.save
      redirect_to parent_special_event_registree_path(@special_registree), notice: 'Special registree was successfully created.'
    else
      render :new
    end
  end

  def update
    if @special_registree.update(special_registree_params)
      redirect_to parent_special_event_registree_path(@special_registree), notice: 'Special registree was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @special_registree.destroy
    redirect_to parent_special_event_url, notice: 'Special registree was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_special_registree
      @special_registree = SpecialRegistree.find_by(special_event: @special_event, parent: current_parent)
    end

    # Only allow a trusted parameter "white list" through.
    def special_registree_params
      params.fetch(:special_registree, {}).permit(:value)
    end
end
