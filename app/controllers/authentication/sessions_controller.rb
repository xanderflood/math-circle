class Authentication::SessionsController < Devise::SessionsController
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?

    render "#{self.class::VIEW_PATH}/new"
  end
end
