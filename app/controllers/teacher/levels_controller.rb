class Teacher::LevelsController < Teacher::BaseController
  def manage
    @levels = Level.all
  end

  def update
    levels = JSON.parse(params["levels"])

    Level.transaction do
      levels.each do |l|
        #TODO new stuff
        Level.update(l)
      end
    end

    redirect_to [:teacher, :levels], notice: "Changes have been saved."
  end
end
