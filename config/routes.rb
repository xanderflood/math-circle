Rails.application.routes.draw do
  devise_for :parents, controllers: { sessions: 'authentication/parent_sessions' }
  devise_for :teachers, controllers: { sessions: 'authentication/teacher_sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  concern :public_routes do
    get '/', to: 'public/home#index'

    # put other public pages here
  end 

  # root namespace roues 
  authenticated :teacher do
    namespace :teacher do
      get '/', to: 'home#index'

      resources :semesters
    end
  end

  authenticated :parent do
    namespace :parent do
      get '/', to: 'home#index'

      resources :students

      # root to: 'parents/home#index'
    end
  end

  unauthenticated concern: :public_routes do
    root to: 'public/home#index'
  end

  # namespace :public, concern: :public_routes do; end
end
