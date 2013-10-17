class CourseRolePagePageview
  include Analytics::Aggregate

  field :course_id, type: Integer
  field :role_group, type: String
  field :page, type: String

  scope_by :course_id, :page, :role_group

  increment_keys "%{granular_key}" => 1

  # course_id: 1,
  # page: "/some/page",
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
