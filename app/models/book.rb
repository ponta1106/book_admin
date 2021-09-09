class Book < ApplicationRecord
  # 価格が3000円より高い本
  scope :costly, -> { where("price > ?", 3000) }
  # :nameに(theme)が含まれている本
  scope :written_about, ->(theme) { where("name like ?", "%#{theme}%") }

  belongs_to :publisher
  has_many :book_authors
  has_many :authors, through: :book_authors

  enum sales_status: {
    reservation: 0, # 予約受付
    now_on_sale: 1, # 発売中
    end_of_print: 2, # 販売終了
  }

  validates :name, presence: true
  validates :name, length: { maximum: 25 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  # 本の名前に「exercise」という文字列が含まれている場合にバリデーションエラーとする
  validate do |book|
    if book.name.include?("exercise")
      book.errors[:name] << "I don't like exercise."
    end
  end

  # 名前に"Cat"が含まれていた場合、"lovely Cat"という文字に置き換える
  before_validation do
    self.name = self.name.gsub(/Cat/) do |matched|
      "lovely #{matched}"
    end
  end

  # 削除後に、削除したデータの内容をログに表示する
  after_destroy do
    Rails.logger.info "Book is deleted: #{self.attributes}"
  end

  # 価格が5,000円以上の本を削除した際に実行するコールバック
  after_destroy :if => :high_price? do
    Rails.logger.warn "Book with high price is deleted: #{self.attributes}"
    Rails.logger.warn "Please check!!"
  end

  def high_price?
    price >= 5000
  end

end
