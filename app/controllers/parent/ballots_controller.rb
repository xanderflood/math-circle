class Parent::BallotsController < Parent::BaseController
  include BallotsControllable
  self.role = :parent

  before_action :check_levels, only: :new

  private
    def check_levels
      if @student.school_grade < 6 || @student.level == 'D'
        redirect_to :back, notice: 'Elementary students and students registering for level D will need to contact Math-Circle directly to register.'
      end
    end
end
