module Api::Helpers::Articles
    extend Grape::API::Helpers

    def check_article(article)
      if article == nil
        error!({ message: 'No article exist with this id' }, 404)
      end
    end

    def check_user(current_user_id, user_id)
      if current_user_id.to_s != user_id.to_s
        error!({ message: 'Unauthorized user'}, 400)
      end
    end

    def update_article(article, params)
      article.update(params)
      article
    end

    def delete_article(article)
        if article
          article.destroy
          status 204
        else
          error!({ message: 'No article exist with this id' }, 404)
        end
    end
end
