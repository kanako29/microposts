class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  paginates_per 6
  has_many :favorites, dependent: :destroy
  has_many :favoriting_users, through: :favorites, source: :user, class_name: "User", foreign_key: "user_id"
end
