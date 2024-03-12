class ArticleApp

  attr_reader :article
  def initialize(article)
    @article = article
  end
  def check_article
    if article == nil
      raise ActiveRecord::RecordNotFound.new 'No article exist with this id'
    else
      article
    end
  end

  def check_user(user_id)
    if article.user_id.to_s != user_id.to_s
      error!({ message: 'Unauthorized user'}, 400)
    end
  end

  def update_article(article, params)
    article.update(params)
    article
  end

  def delete_article
    if article
      article.destroy
      status 204
    else
      error!({ message: 'No article exist with this id' }, 404)
    end
  end
end
