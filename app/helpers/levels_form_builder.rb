module LevelsFormBuilder
  def level_select(method, options = {}, html_options = {}) 
    levels = Level.active
    if options.delete(:include_inactive)
      levels = levels.where(active: true)
    end
    options[:include_blank] = true

    self.collection_select(method, levels, :id, :name, options, html_options)
  end
end
