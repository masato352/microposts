module FollowingsHelper
  def gravatar_for(followings, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(followings.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: followings.name, class: "gravatar")
  end
end