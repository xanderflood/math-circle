Rails.application.routes.draw do

  get 'errors/not_found'

  get 'docs/waiver'

  devise_for :parents, controllers: { sessions: 'authentication/parent_sessions' }
  devise_for :teachers, controllers: { sessions: 'authentication/teacher_sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  concern :public_routes do
    get '/', to: 'public/home#index'

    resources :courses, only: :show
  end

  authenticated :teacher do
    namespace :teacher do
      get '/', to: 'home#index', as: 'home'

      resources :semesters do
        post 'act/:transition(/:lottery_id)', action: 'act', as: 'act'

        get  :lottery

        # resetting priorities
        collection do
          get 'priorities/manage'
          post 'priorities/reset'
        end
      end

      resources :special_events,              except: :index

      resources :courses,                     except: :index

      resources :sections,                    except: :index do
        get 'attendance' # download the attendance record
      end

      # TODO: is this still in use?
      resources :sections, as: :event_groups, except: :index

      resources :events,                      except: :index do
        resource :rollcall, only: :show
      end

      resources :rollcalls, only: [:create, :update]

      resources :parents,   only: [:index, :destroy] do
        collection do
          get 'search'
        end

        resources :students, only: [:index, :new], controller: 'parents/students'
        resource :profile,   only: [:show, :edit, :update]
      end

      resources :students, except: [:new] do
        collection do
          get 'search_form'
          get 'search'
          get 'name'
        end

        resource :ballot,    except: [:show, :index]
        resource :registree, except: [:show, :index] do
          get :courses, as: 'courses'
        end
      end

      get '*path', to: 'errors#not_found'
    end
  end

  authenticated :parent do
    namespace :parent do
      get '/',        to: 'home#index',    as: 'home'
      get 'catalog',  to: 'home#catalog',  as: 'catalog'
      get 'schedule', to: 'home#schedule', as: 'schedule'

      resources :special_events, only: [:index] do
        resource :special_registree, except: [:index, :new, :edit]
      end

      resource :profile, only: [:show, :create, :update]

      resources :students do
        get 'schedule', on: :member

        resource :ballot,    except: [:show, :index]
        resource :registree, except: [:show, :index] do
          get :courses, as: 'courses'
        end
      end

      get '*path', to: 'errors#not_found'
    end
  end

  unauthenticated concern: :public_routes do
    root to: 'public/home#index'

    devise_scope :teacher do
      scope :teacher do
        root        to: 'authentication/teacher_sessions#new'
        get '*all', to: 'authentication/teacher_sessions#new'
      end
    end

    devise_scope :parent do
      scope :parent do
        root        to: 'authentication/parent_sessions#new'
        get '*all', to: 'authentication/parent_sessions#new'
      end
    end
  end

  get 'docs/waiver'
end
