module NavHelper
  def content_nav_for(*objects, &block)
    capture_haml do
      haml_tag :div, class: 'content-nav' do
        haml_concat breadcrumbs_for(*objects)
        haml_concat content_nav(&block)
      end
    end
  end

  def content_nav(&block)
    capture_haml do
      haml_tag :div, class: 'navbar navbar-inverse' do
        haml_tag :ul, class: 'nav navbar-nav', &block if block
      end
    end
  end
end