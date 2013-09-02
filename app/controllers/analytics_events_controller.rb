class AnalyticsEventsController < ApplicationController
  skip_before_filter :increment_page_views

  def predictor_event
    EventLogger.perform_async('predictor', current_course.id, current_user.id, params[:assignment], {:score => params[:score].to_i, :possible => params[:possible].to_i})
    render :nothing => true, :status => :ok
  end
end
