class Teacher::LevelsController < Teacher::BaseController
  def manage
    @levels = Level.all
  end

  def update
    levels = JSON.parse(params["levels"])

    ids = []
    begin
      Level.transaction do
        levels.each do |level_data|
          level_data = level_data.clone

          if id = level_data.delete("id")
            level = Level.find(id)
            level.update!(level_data)
            ids << level.id
          else
            level = Level.create!(level_data)
            ids << level.id
          end
        end
      end

      Level.where('id NOT IN (?)', ids).each do |level|
        level.destroy!
      end
    rescue StandardError => e
      LotteryError.save(e)

      flash.alert = "Could not save changes, please try again."
      @levels = levels.map { |level| Level.new(level) }
      render :manage
      return
    end

    redirect_to [:teacher, :levels], notice: "Changes have been saved."
  end
end
