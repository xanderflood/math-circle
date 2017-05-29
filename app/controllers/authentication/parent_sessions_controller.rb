class Authentication::ParentSessionsController < Authentication::SessionsController
  VIEW_PATH = 'parents/sessions'

  def after_sign_in_path_for(resource)
    sign_in_url = new_parent_session_url
    if request.referer == sign_in_url
      parent_path
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end
end
