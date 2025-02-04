# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
class Article < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :content, presence: true
  validates :images,
  attached_file_number: { maximum: 4 },
  attached_file_size: { maximum: 5.megabytes },
  attached_file_presence: true #Active Recordの汎用的なバリデーションで、ActiveStorageのバリデーションよりも先に評価されてしまうので最後に記載。
end
