class Parent::BallotsController < Parent::BaseController
  include BallotsControllable
  self.role = :parent

  before_action :check_levels, only: :new

  private
    def check_levels
      unless @student.permitted?
        redirect_to :back, notice: "Grade #{@student.school_grade} students registering in level #{@student.level} must be manually registered by a Math-Circle teacher."
      end
    end
end
