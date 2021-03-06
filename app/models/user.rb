class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  # プロファイルとエリア
  validates :profile , length: { maximum: 50 } , presence: false
  validates :area , length: { maximum: 10 } , presence: false  
  
  # 8.2で追加
  has_many :microposts  

  # 9.2で追加
  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed

  has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
  has_many :follower_users, through: :follower_relationships, source: :follower

  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.find_or_create_by(followed_id: other_user.id)
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end
  
  # 機能拡張（お気に入り）で追加
  has_many :likes, 
            dependent:   :destroy
  has_many :favorite_microposts, through: :likes, source: :micropost 
  
  # like
  def like(micropost)
    likes.find_or_create_by(micropost_id: micropost.id)
  end

  # dislike
  def dislike(micropost)
    like = likes.find_by(micropost_id: micropost.id)
    like.destroy if like
  end  

  # あるマイクロポストをフォローしているかどうか？
  def like?(micropost)
    favorite_microposts.include?(micropost)
  end
 
  # タイムラインを取得
  def feed_items
    Micropost.where(user_id: following_user_ids + [self.id])
  end
  
end