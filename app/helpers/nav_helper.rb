module NavHelper
  def content_nav_for(*objects, &block)
    capture_haml do
      haml_tag :div, class: 'content-nav show-for-medium-up' do
        haml_concat content_nav(&block)
      end
      haml_tag :div, class: 'content-nav hide-for-medium-up' do
        haml_concat mobile_nav(&block)
      end
    end
  end

  def content_nav(&block)
    capture_haml do
      haml_tag :dl, class: 'sub-nav show-for-medium-up' do
        haml_tag :dd, class: 'navbar-nav', &block if block
      end
    end
  end

  def mobile_nav(&block)
    capture_haml do
      haml_tag :div, class: 'columns hide-for-medium-up' do
        haml_tag :a, :class => 'radius button tiny small-12 dropdown', :href => "#", :data => { :dropdown => "drop" } do
          haml_tag :span, "Options"
        end
        haml_tag :ul, :id => 'drop', :class => 'f-dropdown', &block if block
      end
    end
  end
end