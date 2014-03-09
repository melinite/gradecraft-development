class TiersController < ApplicationController
  before_action :find_tier, except: [:new, :create]
  after_action :respond_with_tier

  def new
    @tier = Tier.new params[:tier]
  end

  def edit
  end

  def create
    @tier = Tier.create params[:tier]
  end

  def destroy
    @tier.destroy
  end

  def show
  end

  def update
    @tier.update_attributes params[:tier]
  end

  private
  def find_tier
    @tier = Tier.find params[:id]
  end

  def respond_with_tier
    respond_with @tier
  end
end
