class ActiveRecord::ReadOnly < ActiveRecord::Base
  def readonly?
    true
  end
end
