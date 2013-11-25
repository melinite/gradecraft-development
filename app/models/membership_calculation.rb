class MembershipCalculation < ActiveRecord::Base
  belongs_to :course
  belongs_to :user

  def is_team_member?
    return !(team_id.nil?)
  end
end
