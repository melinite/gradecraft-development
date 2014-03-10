class AdminConstraint
  def matches?(request)
    user = User.find_by_id(request.session[:user_id])
    user.present? && user.is_admin?
  end
end
