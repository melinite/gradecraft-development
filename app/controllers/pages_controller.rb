class PagesController < ApplicationController
  skip_before_filter :require_login

  def lti_error
  end

  def documentation
    if current_user
      if current_user.is_student?
        @user = current_user
        @badges = current_course.badges
        @assignments = current_course.assignments
      end
    end
  end

  def features
    if current_user
      if current_user.is_student?
        @user = current_user
        @badges = current_course.badges
        @assignments = current_course.assignments
      end
    end
  end

  def research
    if current_user
      if current_user.is_student?
        @user = current_user
        @badges = current_course.badges
        @assignments = current_course.assignments
      end
    end
  end

  def people
    if current_user
      if current_user.is_student?
        @user = current_user
        @badges = current_course.badges
        @assignments = current_course.assignments
      end
    end
  end

  def using_gradecraft
    if current_user
      if current_user.is_student?
        @user = current_user
        @badges = current_course.badges
        @assignments = current_course.assignments
      end
    end
  end
end
