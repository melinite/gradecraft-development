GradeCraft::Application.routes.draw do
  resources :challenge_grades
  resources :challenges

  %w{students gsis professors admins}.each do |role|
    get "users/#{role}/new" => 'users#new', :as => "new_#{role.singularize}", :role => role.singularize
  end

  resources :users do
    collection do
      get 'edit_profile'
      get 'predictor'
      put 'update_profile'
      get 'students'
      get 'staff'
      get 'final_grades'
      get 'test'
      get 'import'
      post 'upload'
      get 'choices'
      get 'analytics'
      get 'my_badges'
    end
    resources :assignment_weights
  end
  resources :user_sessions

  match 'auth/:provider/callback', to: 'user_sessions#lti_create', via: [:get, :post]
  get 'lti/:provider/launch', to: 'lti#launch', :as => :launch_lti_provider
  get 'lti_error' => 'pages#lti_error', :as => :lti_error

  resources :password_resets
  resources :info
  resources :home
  resources :group_memberships
  resources :categories
  resources :courses
  resources :course_memberships
  resources :badge_sets
  resources :badges do
    resources :tasks
  end
  resources :earned_badges do
    collection do
      get :mass_award
      put :mass_update
      get :chart
    end
  end
  resources :teams do
    collection do
      get :activity
    end
    resources :earned_badges
  end
  resources :assignment_types
  resources :score_levels
  resources :groups, :only => :index
  resources :assignments do
    collection do
      get :settings
      get :feed
    end
    resources :submissions
    resources :tasks
    resources :groups
    resources :grades do
      collection do
        get :mass_edit
        put :mass_update
        post :edit_status
        put :update_status
        get :self_log
        post :self_log_create
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

  get 'gradebook' => 'grades#gradebook'
  get 'home/index'
  get 'dashboard' => 'info#dashboard'
  root :to => "home#index"

  post '/current_course/change' => 'current_courses#change', :as => :change_current_course
  get 'current_course' => 'current_courses#show'

  get 'login' => 'user_sessions#new', :as => :login
  get 'logout' => 'user_sessions#destroy', :as => :logout
  get 'submit_a_bug' => 'pages#submit_a_bug'
  get 'features' => 'pages#features'
  get 'research' => 'pages#research'
  get 'news' => 'pages#news'
  get 'using_gradecraft' => 'pages#using_gradecraft'
  get 'people' => 'pages#people'
  get 'contact' => 'pages#contact'

  # get 'cosign_test' => 'info#cosign_test'
end
