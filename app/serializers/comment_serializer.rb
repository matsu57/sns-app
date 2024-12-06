class CommentSerializer < ActiveModel::Serializer
  attributes :id, :article_id, :user_id, :content
end
