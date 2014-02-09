class PagesController < ApplicationController
  skip_before_filter :require_login

  def lti_error
  end

  def documentation
  end

  def features
  end

  def research
  end

  def people
  end

  def using_gradecraft
  end

  def ping
    respond_to do |format|
      format.json { render json: { 'pong' => true } }
      format.html { render text: 'pong' }
    end
  end
end
