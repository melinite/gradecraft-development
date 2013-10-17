class CourseUserPagePageview
  include Analytics::Aggregate

  field :course_id, type: Integer
  field :user_id, type: Integer
  field :page, type: String

  scope_by :course_id, :page, :user_id

  increment_keys "%{granular_key}" => 1

  # course_id: 1,
  # user_id: 2,
  # page: "/some/page",
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
end
