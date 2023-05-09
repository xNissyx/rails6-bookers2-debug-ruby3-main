class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  # validates :tag, presence: true

  scope :latest, -> {order(created_at: :desc)}
  scope :evaluation_count, -> {order(evaluation: :desc)}
  # scope :favorites_count, -> { where(favorite: { created_at: 1.week.ago..Time.current }) }
   scope :with_favorites_count, -> { 
    joins(:favorites)
      .where(favorites: { created_at: 1.week.ago..Time.current })
      .group('books.id')
      .select('books.*, COUNT(favorites.id) AS favorites_count')
      .order(favorites_count: :DESC)
  }

  def self.looks(method,word)
    if method == "perfect_matching"
      @books = Book.where("title LIKE ?", "#{word}")
    elsif method == "forward_matching"
      @books = Book.where("title LIKE ?", "#{word}%")
    elsif method == "backward_matching"
      @books = Book.where("title LIKE ?", "%#{word}")
    elsif method == "partial_matching"
      @books = Book.where("title LIKE ?", "%#{word}%")
    end
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
