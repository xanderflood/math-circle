class Teacher::LevelsController < Teacher::BaseController
  def manage
    @levels = Level.all
  end

  def update
    # TODO
  end
end
