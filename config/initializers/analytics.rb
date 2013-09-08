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
      CoursePageviewByTime,
      CoursePagePageview
    ],
    login: [
      CourseLogin,
      CourseUserLogin
    ]
  }
end
