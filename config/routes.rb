Rails.application.routes.draw do
  devise_for :parents, controllers: { sessions: 'authentication/parent_sessions' }
  devise_for :teachers, controllers: { sessions: 'authentication/teacher_sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  concern :public_routes do
    get '/', to: 'public/home#index'

    # put other public pages here
  end 

  authenticated :teacher do
    namespace :teacher do
      get '/', to: 'home#index', as: 'home'

      resources :semesters

      resources :courses

      resources :events, only: [ :index, :edit, :update, :destroy ]

      resources :event_groups do
        resources :events, only: [ :index, :new, :create ]
      end
    end
  end

  authenticated :parent do
    namespace :parent do
      get '/', to: 'home#index', as: 'home'

      resources :students do
        resources :ballots, except: [:edit, :show, :index] do
          # multistep form
          # get :start
          # get :courses
          # get :preference_poll
          # post :register
        end
      end

      resources :events, only: [ :index, :show ]
    end
  end

  unauthenticated concern: :public_routes do
    root to: 'public/home#index'
  end
end
