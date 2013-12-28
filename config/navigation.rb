SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = SimpleNavigation::Renderer::List

  navigation.selected_class = 'selected'

  navigation.active_leaf_class = 'simple-navigation-active-leaf'

  navigation.items do |primary|
    primary.item :key_1, 'Basic Settings', edit_course_path(current_course)
    primary.item :key_2, 'Grading Scheme', grade_schemes_path
    primary.item :key_3, 'Assignment Types', assignment_types_path
    primary.item :key_4, "#{current_course.assignment_term}s", assignments_path
    primary.item :key_5, "#{current_course.team_term}s", teams_path
    primary.item :key_7, "#{current_course.badge_term}s", badges_path
    primary.item :key_8, "Tasks", tasks_path
    primary.item :key_9, "#{current_course.user_term}s", students_path

    primary.item :key_10, "Users", users_path do |sub_nav|
      sub_nav.item :key_10_1, "{current_course.user_term}", students_path
      sub_nav.item :key_10_2, "Staff", staff_users_path
      sub_nav.item :key_10_3, "All Users", all_users_path
    end
    primary.item :key_11,  "#{current_course.multiplier_term} Choices", choices_users_path
    primary.item :key_13, "Import Users", import_users_path
    primary.item :key_16, "Course Index", courses_path
    primary.item :key_17, "New Course", new_course_path
    primary.item :key_18, "#{current_course.challenge_term}s", challenges_path
    primary.item :key_18, "#{current_course.group_term}s", groups_path

  end

end
