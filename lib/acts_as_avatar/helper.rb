module ActsAsAvatar
  module Helper
    def acts_as_avatar(object, size=120)
      if object.current_avatar.attached?
        object.current_avatar.variant(resize_to_fill: [size, size])
      else
        "admin/profile-img.jpg"
      end
    end
  end
end
