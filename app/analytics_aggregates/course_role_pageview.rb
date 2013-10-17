class CourseRolePageview
  include Analytics::Aggregate

  field :course_id, type: Integer
  field :role_group, type: String

  scope_by :course_id, :role_group

  increment_keys "%{granular_key}" => 1

  # course_id: 1,
  # role_group: "student",
  # all_time: %,
  # yearly: {
  #   key: %
  # },
  # monthly: {
  #   key: %
  # },
  # weekly: {
  #   key: %
  # },
  # daily: {
  #   key: %
  # },
  # hourly: {
  #   key: %
  # },
  # minutely: {
  #   key: %
  # }

  def self.decorate_event(event)
    event[:role_group] = event.user_role == "student" ? "student" : "staff"
    event
  end
end
