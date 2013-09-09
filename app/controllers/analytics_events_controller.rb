class AnalyticsEventsController < ApplicationController
  skip_before_filter :increment_page_views

  def predictor_event
    EventLogger.perform_async('predictor',
                                course_id: current_course.id,
                                user_id: current_user.id,
                                user_role: current_user.role,
                                assignment_id: params[:assignment].to_i,
                                score: params[:score].to_i,
                                possible: params[:possible].to_i,
                             )
    render :nothing => true, :status => :ok
  end
end
