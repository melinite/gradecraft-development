class LTIProvider < ActiveRecord::Base

  def to_param
    uid
  end
end
