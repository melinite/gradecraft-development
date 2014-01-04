module BreadcrumbsHelper
  def breadcrumbs_for(*breadcrumbs)
    breadcrumbs = expand_breadcrumbs(breadcrumbs)
    capture_haml do
      haml_tag :ul, class: 'breadcrumbs' do
        breadcrumbs.each_with_index do |breadcrumb, i|
          previous = breadcrumbs[i - 1] if i > 0
          haml_concat breadcrumb_for breadcrumb, previous: previous, active: breadcrumbs.last == breadcrumb
        end
      end
    end
  end

  def expand_breadcrumbs(breadcrumbs)
    [:dashboard].tap do |expanded|
      breadcrumbs.inject([]) do |context, breadcrumb|
        case breadcrumb
        when Class
          expanded << [breadcrumb, context + [breadcrumb]]
        when ActiveRecord::Base
          expanded << [breadcrumb.class, context + [breadcrumb.class]]
          expanded << [breadcrumb, context + [breadcrumb]]
        else
          expanded << breadcrumb
        end
        context + [breadcrumb]
      end
    end
  end

  def breadcrumb_for(object, options = {})
    capture_haml do
      if options[:active]
        haml_tag :li, breadcrumb_text_for(object, options), class: 'active'
      else
        haml_tag :li, breadcrumb_link_for(object, options)
      end
    end
  end

  def breadcrumb_link_for(object, options = {})
    link_to breadcrumb_text_for(object, options), breadcrumb_url_for(object, options)
  end

  def breadcrumb_url_for(object, options = {})
    case object
    when Array
      url_for(object[1])
    when ActiveRecord::Base
      url_for(object)
    else
      object
    end
  end

  def breadcrumb_text_for(object, options = {})
    case object
    when :dashboard, :root, :home
      'Home'
    when Array
      breadcrumb_text_for(object[0], options = {})
    when Class
      plural = object.model_name.plural
      term_for plural.to_sym, plural.titleize
    when ActiveRecord::Base
      if object.persisted?
        object.name
      else
        plural = object.class.model_name.plural
        term_for plural.to_sym, plural.titleize
      end
    else
      if options[:prevous]
        object % breadcrumb_link_for(options[:previous])
      else
        object
      end
    end
  end
end
