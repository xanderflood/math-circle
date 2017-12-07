class Teacher::PrioritiesController < ApplicationController
  before_action :set_threshold

  DEFAULT_THRESHOLD = 4

  def manage
  end

  def reset
    flash[:notice] = "Threshold is #{@threshold}."
    render :manage
  end

  private
  def set_threshold
    @threshold = params[:threshold] || DEFAULT_THRESHOLD
  end
end
