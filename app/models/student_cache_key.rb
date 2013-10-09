class StudentCacheKey < ActiveRecord::Base
  belongs_to :course_membership
end
