Rails.application.routes.draw do
  devise_for :parents, controllers: { sessions: 'authentication/parent_sessions' }
  devise_for :teachers, controllers: { sessions: 'authentication/teacher_sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  concern :public_routes do
    get '/', to: 'public/home#index'

    resources :courses, only: :show

    # put other public pages here
  end 

  authenticated :teacher do
    namespace :teacher do
      get '/', to: 'home#index', as: 'home'

      resources :semesters do
        get  :lottery
        post :lottery, to: 'semesters#commit_lottery'
      end

      resources :special_events,              except: :index

      resources :courses,                     except: :index

      resources :sections,                    except: :index do
        get 'attendance' # download the attendance record
      end

      # TODO: is this still in use?
      resources :sections, as: :event_groups, except: :index

      resources :events,                      except: :index do
        # get  :rollcall
        # post  :rollcall, to: 'events#create_rollcall', as: 'rollcalls'
        # patch :rollcall, to: 'events#update_rollcall'

        resource :rollcall, only: :show
      end
      
      resources :rollcalls, only: [:create, :update]
    end
  end

  authenticated :parent do
    namespace :parent do
      get '/',       to: 'home#index',   as: 'home'
      get 'catalog', to: 'home#catalog', as: 'catalog'

      resource :profile, only: [:show, :create, :update]

      resources :students do
        resources :ballots, except: [:edit, :show, :index]
      end
    end
  end

  unauthenticated concern: :public_routes do
    root to: 'public/home#index'
  end
end
