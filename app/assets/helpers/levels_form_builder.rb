class LevelsFormBuilder < ActionView::Helpers::FormBuilder
  def level_select(method, options = {}, html_options = {}) 
    levels = Level.all
    if options.delete(:include_inactive)
      levels = levels.where(active: true)
    end
    options[:include_blank] = true

    collection_select(@object, method, levels, :id, :level, options, html_options)
  end
end
