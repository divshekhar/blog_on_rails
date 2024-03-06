class ArticleEntity < Grape::Entity
  expose :title
  expose :body
  expose :slug
  expose :visibility
  expose :user_id
end