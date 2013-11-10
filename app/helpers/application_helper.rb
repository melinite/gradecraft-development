module ApplicationHelper
  include CustomNamedRoutes

  def body_class
    classes = []
    if logged_in?
      classes << 'logged-in'
      classes << 'staff' if current_user.is_staff?
      classes << current_user.role
    else
      classes << 'logged-out'
    end
    classes.join ' '
  end

  # Return a title on a per-page basis.
  def title
    base_title = ""
    if @title.nil?
      base_title
    else
      "#{@title}"
    end
  end

  # Add class="current" to navigation item of current page
  def cp(path)
    "current" if current_page?(path)
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def autocomplete_items
    return [] unless current_user.is_staff?
    User.students.map do |u|
      { :name => [u.first_name, u.last_name].join(' '), :id => u.id }
    end
  end

  def success_button_class(classes = nil)
    [classes, 'btn btn-tiny btn-success'].compact.join(' ')
  end

  def table_link_to(name = nil, options = nil, html_options = nil, &block)
    html_options ||= {}
    html_options[:class] = [html_options[:class], 'btn btn-tiny btn-success'].compact.join(' ')
    link_to name, options, html_options, &block
  end

  def points(value)
    number_with_delimiter(value)
  end
end
