class AnalyticsController < ApplicationController
  before_filter :ensure_staff?

  def events
  end
end
