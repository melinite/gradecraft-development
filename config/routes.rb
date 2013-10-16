GradeCraft::Application.routes.draw do

  #1. Analytics & Charts
  #2. Assignments, Submissions, Tasks, Grades
  #3. Assignment Types
  #4. Assignment Type Weights
  #5. Badges
  #6. Categories
  #7. Challenges
  #8. Courses
  #9. Groups
  #10. Informational Pages
  #11. Rubrics & Grade Schemes
  #12. Teams
  #13. Users
  #14. User Auth

  #1. Analytics & Charts
  namespace :analytics do
    root :to => :index
    get :all_events
    get :assignment_events
    get :login_frequencies
    get :login_events
    get :all_pageview_events
    get :pageview_events
    get :prediction_averages
    get :assignment_prediction_averages
  end

  post 'analytics_events/predictor_event'
  post 'analytics_events/tab_select_event'

  resources :charts do
    collection do
      get :per_assign
      get :team_grade
    end
  end

  #2. Assignments, Submissions, Tasks, Grades
  resources :assignments do
    collection do
      get :feed
      get :settings
      get 'weights' => 'assignment_weights#mass_edit', :as => :mass_edit_weights
    end
    member do
      get 'mass_grade' => 'grades#mass_edit', as: :mass_grade
      put 'mass_grade' => 'grades#mass_update'
      get 'group_grade' => 'grades#group_edit', as: :group_grade
      put 'group_grade' => 'grades#group_update'
      scope 'grades', as: :grades, controller: :grades do
        post :edit_status
        put :update_status
        post :self_log
        post :predict_score
      end
    end
    resources :submissions
    resources :tasks
    resource :grade, only: [:show, :edit, :update, :destroy] do
      resources :earned_badges
    end
  end

  resources :score_levels

  #3. Assignment Types
  resources :assignment_types


  #4. Assignment Type Weights
  get 'assignment_type_weights' => 'assignment_type_weights#mass_edit', as: :assignment_type_weights
  put 'assignment_type_weights' => 'assignment_type_weights#mass_update'

  resources :assignment_weights

  #5. Badges
  resources :badge_sets
  resources :badges do
    resources :tasks
    resources :earned_badges do
      post :toggle_shared
      collection do
        get :chart
      end
    end
    member do
      get 'mass_award' => 'earned_badges#mass_edit', as: :mass_award
      put 'mass_award' => 'earned_badges#mass_update'
    end
  end

  #6. Categories
  resources :categories

  #7. Challenges
  resources :challenges do
    resources :challenge_grades do
      collection do
        get :mass_edit
      end
    end
  end

  #8. Courses
  resources :courses do
    collection do
      get :all_grades
    end
  end
  resources :course_memberships

  post '/current_course/change' => 'current_courses#change', :as => :change_current_course
  get 'current_course' => 'current_courses#show'
  get  'class_badges' => 'students#class_badges'

  get 'leaderboard' => 'info#leaderboard'
  get 'grading_status' => 'info#grading_status'
  get 'all_grades' => 'courses#all_grades'

  #9. Groups
  resources :groups
  resources :group_memberships

  #10. Informational Pages
  resources :info
  resources :home

  get 'submit_a_bug' => 'pages#submit_a_bug'
  get 'features' => 'pages#features'
  get 'research' => 'pages#research'
  get 'news' => 'pages#news'
  get 'using_gradecraft' => 'pages#using_gradecraft'
  get 'people' => 'pages#people'
  get 'contact' => 'pages#contact'
  get 'documentation' => 'pages#documentation'

  #11. Rubrics & Grade Schemes
  resources :rubrics do
    resources :criteria
  end
  resources :grade_schemes do
    resources :grade_scheme_elements
    collection do
      post :destroy_multiple
    end
  end

  #12. Teams
  resources :teams do
    collection do
      get :activity
    end
    resources :earned_badges
  end

  get 'home/index'
  get 'dashboard' => 'info#dashboard'
  root :to => "home#index"

  #13. Users
  %w{students gsis professors admins}.each do |role|
    get "users/#{role}/new" => 'users#new', :as => "new_#{role.singularize}", :role => role.singularize
  end

  resources :users do
    collection do
      get :edit_profile
      get :all
      put :update_profile
      get :predictor
      get :test
      get :import
      post :upload
      get :analytics
    end
  end
  resources :students do
    get :grade_index
    collection do
      get :leaderboard
      get :choices
      get :scores_for_current_course
      get :scores_by_assignment
      get :scores_by_team
      get :scores_for_single_assignment
      get :final_grades
      get :class_badges
    end
  end
  resources :staff, only: [:index, :show]
  resources :user_sessions
  resources :password_resets

  #14. User Auth
  post 'auth/kerberos/callback', to: 'user_sessions#kerberos_create', as: :auth_kerberos_callback
  match 'auth/lti/callback', to: 'user_sessions#lti_create', via: [:get, :post]
  get 'auth/failure' => 'pages#auth_failure', as: :auth_failure

  get 'login' => 'user_sessions#new', :as => :login
  get 'logout' => 'user_sessions#destroy', :as => :logout
  get 'reset' => 'user_sessions#new'


  get 'lti/:provider/launch', to: 'lti#launch', :as => :launch_lti_provider

  # get 'cosign_test' => 'info#cosign_test'
end
