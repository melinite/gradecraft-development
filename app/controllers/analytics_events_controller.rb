class AnalyticsEventsController < ApplicationController
  skip_before_filter :increment_page_views

  def predictor_event
    EventLogger.perform_async('predictor', {:score => params[:score], :possible => params[:possible]}, current_user.id, params[:assignment])
    render :nothing => true, :status => :ok
  end
end
