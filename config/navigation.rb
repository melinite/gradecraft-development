SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = SimpleNavigation::Renderer::List

  navigation.selected_class = 'selected'

  navigation.active_leaf_class = 'simple-navigation-active-leaf'

  navigation.items do |primary|
    primary.item :key_1, 'Basic Settings', edit_course_path(current_course)
    primary.item :key_2, 'Grading Scheme', course_grade_schemes_path
    primary.item :key_3, 'Assignment Types', assignment_types_path
    primary.item :key_4, 'Assignments', assignments_path
    primary.item :key_5, "#{current_course.team_term}s", teams_path
    primary.item :key_6, "Badge Sets", badge_sets_path
    primary.item :key_7, "Badges", badges_path
    primary.item :key_8, "Themes", themes_path
    primary.item :key_9, "#{current_course.team_term}s", teams_path

    primary.item :key_10, "Users", users_path do |sub_nav|
      sub_nav.item :key_10_1, "Students", students_users_path
      sub_nav.item :key_10_2, "Staff", staff_users_path
      sub_nav.item :key_10_3, "All Users", all_users_path
    end
    primary.item :key_11,  "#{current_course.multiplier_term} Choices", choices_users_path
    primary.item :key_13, "Import Users", import_users_path
    primary.item :key_14, "Themes", themes_path
    primary.item :key_16, "Course Index", courses_path
    primary.item :key_17, "New Course", new_course_path    

  end

end
