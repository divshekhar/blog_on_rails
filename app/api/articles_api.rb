module API
  class Articles < Grape::API
    version 'v1', using: :header, vendor: 'api'
    format :json
    prefix :api

    resource :articles do
      desc 'Return all articles'
      get do
        articles = Article.all
        present articles, with: ArticleEntity
      end

      desc 'Return a specific article'
      params do
        requires :id, type: Integer, desc: 'Article ID'
      end
      get ':id' do
        article = Article.find_by(id: params[:id])
        if article
          article
        else
          error!({ message: 'No article exist with this id' }, 404)
        end

      end

      desc 'Create an article'
      params do
        requires :title, type: String, desc: 'Article title'
        requires :body, type: String, desc: 'Article body'
        requires :visibility, type: Boolean, desc: 'Article visibility'
        requires :slug, type: String, desc: 'Article slug'
      end
      post do
        author = User.find_by(id: 1)
        article = author.articles.new(title: params[:title], body: params[:body], visibility: params[:visibility], slug: params[:slug])
        if article.save
          article
        else
          error!({ message: article.errors.full_messages.join(', ') }, 400)
        end
      end

      desc 'Delete an article'
      params do
        requires :id, type: Integer, desc: 'Article ID'
        requires :user_id, type: Integer, desc: 'User ID'
      end
      delete ':id' do
        article = Article.find_by(id: params[:id])
        if article.user_id != user_id do
          error!({ message: 'Unauthorized access in delete'}, 400)
        end
        if article
          article.destroy
          status 204
        else
          error!({ message: 'No article exist with this id' }, 404)
        end
      end

      desc 'Change visibility of an article'
      params do
        requires :id, type: Integer, desc: 'Article ID'
        requires :visibility, type: Boolean, desc: 'New visibility status'
      end
      put ':id/visibility' do
        Article.find(params[:id]).update!(visibility: params[:visibility])
      rescue => _error
        error!({ message: 'No article exist with this id' }, 404)
      end

      desc 'Change author of an article'
      params do
        requires :id, type: Integer, desc: 'Article ID'
        requires :user_id, type: String, desc: 'New author id'
      end
      put ':id/author' do
        article = Article.find_by(id: params[:id])
        if article
          article.update(user_id: params[:user_id])
          article
        else
          error!({ message: 'No article exist with this id' }, 404)
        end
      end
    end
  end
end
