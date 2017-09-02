class Parent::SpecialRegistreesController < Parent::BaseController
  before_action :set_special_event
  before_action :set_special_registree

  def show
  end

  def create
    @special_registree.value = params[:special_registree][:value]

    if @special_registree.save
      redirect_to parent_special_events_path, notice: 'Special registree was successfully created.'
    else
      render :show
    end
  end

  def update
    if @special_registree.update(value: params[:special_registree][:value])
      redirect_to parent_special_events_path, notice: 'Special registree was successfully updated.'
    else
      render :show
    end
  end

  def destroy
    @special_registree.destroy
    redirect_to parent_special_events_path, notice: 'Special registree was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_special_event
      @special_event = SpecialEvent.find(params[:special_event_id])
    end

    def set_special_registree
      @special_registree = @special_event.fetch_registree(current_parent)
    end

    # Only allow a trusted parameter "white list" through.
    def special_registree_params
      params.fetch(:special_registree, {}).permit(:value)
    end
end
