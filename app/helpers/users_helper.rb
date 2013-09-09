module UsersHelper
  def gravatar_for(user, options = { })
    gravatar_image_tag(user.email.downcase, :alt => h(user.name),
                                            :class => 'img-rounded',
                                            :gravatar => options)

  end
end
