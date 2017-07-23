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

      resources :sections,                    except: :index
      resources :sections, as: :event_groups, except: :index

      resources :events,                      except: :index do
        get  :rollcall
        post  :rollcall, to: 'events#create_rollcall', as: 'rollcalls'
        patch :rollcall, to: 'events#update_rollcall'
      end
    end
  end

  authenticated :parent do
    namespace :parent do
      get '/', to: 'home#index', as: 'home'

      resources :students do
        get 'catalog'

        resources :ballots, except: [:edit, :show, :index]
      end

      resources :events, only: [ :index, :show ]
    end
  end

  unauthenticated concern: :public_routes do
    root to: 'public/home#index'
  end
end
