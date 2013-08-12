module CustomNamedRoutes
  def self.included(base)
    public_instance_methods.map do |url_route|
      path_route = url_route.to_s.sub(/url$/, 'path')
      if !method_defined?(path_route)
        define_method path_route do |record, options = {}|
          send url_route, record, options.merge(:only_path => true)
        end
      end
      if base < ApplicationController
        puts url_route.inspect
        base.helper_method url_route, path_route
      end
    end
  end

  def criterium_url(record, options = {})
    if record.is_a?(Criterium)
      rubric_criterium_url(record.rubric, record, options)
    else
      super
    end
  end

  def new_criterium_url(record, options = {})
    if record.is_a?(Rubric)
      new_rubric_criterium_url(record, options)
    else
      super
    end
  end

  def edit_criterium_url(record, options = {})
    if record.is_a?(Criterium)
      edit_rubric_criterium_url(record.rubric, record, options)
    else
      super
    end
  end
end
