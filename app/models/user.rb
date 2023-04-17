class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_one_attached :profile_image

  validates :name, length: {in: 2..20}, uniqueness: true
  validates :introduction, length: {maximum: 50}

  # ふぉろー/フォロワー機能
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destoroy

  has_many :followings, through: :active_relationships, source: :followed
  has_many :follower, through: :passive_relationships, source: :follower

  #   # ユーザーをフォローする
  # def follow(other_user)
  #   active_relationships.create(followed_id: other_user.id)
  # end

  # # ユーザーをアンフォローする
  # def unfollow(other_user)
  #   active_relationships.find_by(followed_id: other_user.id).destroy
  # end

  # # 現在のユーザーがフォローしてたらtrueを返す
  # def following?(other_user)
  #   following.include?(other_user)
  # end

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
