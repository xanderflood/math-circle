module Searchable
  extend ActiveSupport::Concern

  # Adding this to a controller:
  #   search :students
  # Will create two actions:
  #   - search_form: does nothing but default rendering
  #   - search: applies search filters to the Students model, asigns
  #      the result to @students, and then does default rendering
  # The second argument can be used to change the instance variable used
  class_methods do
    def search(model_name, variable_name=model_name)
      define_method(:search_form) { }
      define_method(:search) do
        klass = model_name.to_s.classify.constantize

        objs = if params[:search][:id].present?
          p = klass.find_by_id(params[:search][:id].to_i)

          [p].compact
        else
          klass.where("first_name ILIKE ?", "%#{params[:search][:first_name].strip}%")
          .where("last_name ILIKE ?",  "%#{params[:search][:last_name].strip}%")
          .where("email ILIKE ?",  "%#{params[:search][:email].strip}%")
        end

        self.instance_variable_set(:"@#{variable_name}", objs)
      end
    end
  end
end
