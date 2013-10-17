Analytics.configure do |config|
  config.event_aggregates = {
    predictor: [
      AssignmentEvent,
      AssignmentPrediction,
      AssignmentUserEvent,
      CourseEvent,
      CoursePrediction,
      CourseUserEvent
    ],
    pageview: [
      CoursePageview,
      CourseUserPageview,
      CourseUserPagePageview,
      CoursePageviewByTime,
      CoursePagePageview,
      CourseRolePageview,
      CourseRolePagePageview
    ],
    login: [
      CourseLogin,
      CourseRoleLogin,
      CourseUserLogin
    ]
  }
end
