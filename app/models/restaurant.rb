class Restaurant < ActiveRecord::Base

  has_many :reviews, dependent: :destroy
  belongs_to :user
  validates :name, length: {minimum: 3}, uniqueness: true

  def build_with_user(attributes = {}, user)
    attributes[:user] ||= user
    build(attributes)
  end
end
