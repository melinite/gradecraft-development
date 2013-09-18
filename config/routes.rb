GradeCraft::Application.routes.draw do

  resources :challenges do
    resources :challenge_grades do
      collection do
        get 'mass_edit'
      end
    end
  end

  %w{students gsis professors admins}.each do |role|
    get "users/#{role}/new" => 'users#new', :as => "new_#{role.singularize}", :role => role.singularize
  end

  resources :users do
    collection do
      get 'edit_profile'
      get 'predictor'
      get 'scores_for_current_course'
      get 'scores_by_assignment'
      get 'scores_by_team'
      get 'scores_for_single_assignment'
      put 'update_profile'
      get 'predictor'
      get 'final_grades'
      get 'test'
      get 'import'
      post 'upload'
      get 'choices'
      get 'analytics'
      get 'class_badges'
    end
  end
  resources :students do
    collection do
      get 'leaderboard'
    end
  end
  resources :staff, only: [:index, :show]
  resources :assignment_weights
  resources :user_sessions

  post 'auth/kerberos/callback', to: 'user_sessions#kerberos_create', as: :auth_kerberos_callback
  match 'auth/lti/callback', to: 'user_sessions#lti_create', via: [:get, :post]
  get 'auth/failure' => 'pages#auth_failure', as: :auth_failure

  get 'lti/:provider/launch', to: 'lti#launch', :as => :launch_lti_provider

  resources :password_resets
  resources :info
  resources :home
  resources :charts do
    collection do
      get 'per_assign'
    end
  end
  resources :group_memberships
  resources :categories
  resources :courses do
    get 'timeline'
  end
  resources :course_memberships
  resources :badge_sets
  resources :badges do
    post 'toggle_shared'
    resources :tasks
    resources :earned_badges do
      collection do
        get :chart
      end
    end
    member do
      get 'mass_award' => 'earned_badges#mass_edit', as: :mass_award
      put 'mass_award' => 'earned_badges#mass_update'
    end
  end
  resources :groups
  resources :teams do
    collection do
      get :activity
      get :leaderboard
    end
    resources :earned_badges
  end
  resources :assignment_types
  get 'assignment_type_weights' => 'assignment_type_weights#mass_edit', as: :assignment_type_weights
  put 'assignment_type_weights' => 'assignment_type_weights#mass_update'
  resources :score_levels
  resources :groups, :only => :index
  resources :assignments do
    collection do
      get :feed
      get :settings
      get 'weights' => 'assignment_weights#mass_edit', :as => :mass_edit_weights
    end
    member do
      get 'mass_grade' => 'grades#mass_edit', as: :mass_grade
      put 'mass_grade' => 'grades#mass_update'
    end
    resources :submissions
    resources :tasks
    resources :grades do
      collection do
        post :edit_status
        put :update_status
        post :self_log
      end
      resources :earned_badges
    end
  end
  resources :rubrics do
    resources :criteria
  end
  resources :grade_schemes do
    resources :grade_scheme_elements
    collection do
      post :destroy_multiple
    end
  end

  namespace :analytics do
    root :to => :index
    get 'all_events'
    get 'assignment_events'
    get 'login_frequencies'
    get 'login_events'
    get 'all_pageview_events'
    get 'pageview_events'
    get 'prediction_averages'
    get 'assignment_prediction_averages'
  end

  get 'home/index'
  get 'dashboard' => 'info#dashboard'
  root :to => "home#index"

  post '/current_course/change' => 'current_courses#change', :as => :change_current_course
  get 'current_course' => 'current_courses#show'
  get  'class_badges' => 'users#class_badges'
  get 'timeline' => 'courses#timeline'

  get 'login' => 'user_sessions#new', :as => :login
  get 'logout' => 'user_sessions#destroy', :as => :logout
  get 'reset' => 'user_sessions#new'
  get 'submit_a_bug' => 'pages#submit_a_bug'
  get 'features' => 'pages#features'
  get 'research' => 'pages#research'
  get 'news' => 'pages#news'
  get 'using_gradecraft' => 'pages#using_gradecraft'
  get 'people' => 'pages#people'
  get 'contact' => 'pages#contact'
  get 'documentation' => 'pages#documentation'
  get 'leaderboard' => 'info#leaderboard'
  get 'grading_status' => 'info#grading_status'

  post 'analytics_events/predictor_event'

  # get 'cosign_test' => 'info#cosign_test'
end
