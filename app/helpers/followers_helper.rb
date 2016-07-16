module FollowersHelper
  def gravatar_for(followers, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(followers.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: followers.name, class: "gravatar")
  end
end