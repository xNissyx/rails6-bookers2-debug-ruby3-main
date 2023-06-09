class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :read_counts, dependent: :destroy
  has_one_attached :profile_image

  validates :name, length: {in: 2..20}, uniqueness: true
  validates :introduction, length: {maximum: 50}

  # ふぉろー/フォロワー機能のアソシエーション
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # DM機能のアソシエーション
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :rooms, dependent: :destroy, through: :entries

  # グループ機能のアソシエーション
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users

  # イベントのアソシエーション
  has_many :events, dependent: :destroy, through: :atendees
  has_many :atendees, dependent: :destroy

  #   # ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # # ユーザーをアンフォローする
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    followings.include?(other_user)
  end

  # ゲストログイン機能
  def self.guest
    find_or_create_by!(name: "guestuser", email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end
  # # case文で書き換えてみた
  # self=クラスメソッド(self.looks)
  class << self
    def looks(method,word)
      case method
      when "perfect"
        @users = User.where(name: "#{word}")
      when "forward"
        @users = User.where("name LIKE ?", "#{word}%")
      when "backward"
        @users = User.where("name LIKE ?", "%#{word}")
      when "partial"
        @users = User.where("name LIKE ?", "%#{word}%")
      end
    end
  end

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
