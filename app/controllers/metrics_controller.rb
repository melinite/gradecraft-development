class MetricsController < ApplicationController
  before_action :find_metric, except: [:new, :create]
  after_action :respond_with_metric

  def new
    @metric = Metric.new params[:metric]
  end

  def edit
  end

  def create
    @metric = Metric.create params[:metric]
  end

  def destroy
    @metric.destroy
  end

  def show
  end

  def update
    @metric.update_attributes params[:metric]
  end

  private
  def find_metric
    @metric = Metric.find params[:id]
  end

  def respond_with_metric
    respond_with @metric
  end
end
