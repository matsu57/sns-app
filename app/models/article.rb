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

  validates :images,
    attached_file_presence: true,
    attached_file_number: { maximum: 4 },
    attached_file_size: { maximum: 5.megabytes }
end
