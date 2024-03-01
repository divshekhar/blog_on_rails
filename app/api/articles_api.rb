# app/api/articles_api.rb
module BlogOnRails
  class ArticlesApi < Grape::API
    version 'v1', using: :header, vendor: 'blogonrails'
    format :json
    prefix :api

    resource :articles do
      desc 'Return all articles'
      get do
        Article.all
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
        requires :author, type: String, desc: 'Article author'
        requires :visibility, type: Boolean, desc: 'Article visibility'
        requires :slug, type: String, desc: 'Article slug'
      end
      post do
        Article.create!(title: params[:title], body: params[:body], author: params[:author], visibility: params[:visibility], slug: params[:slug])
      end

      desc 'Delete an article'
      params do
        requires :id, type: Integer, desc: 'Article ID'
      end
      delete ':id' do
        article = Article.find_by(id: params[:id])
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
        article = Article.find_by(id: params[:id])
        if article
          article.update(visibility: params[:visibility])
          article
        else
          error!({ message: 'No article exist with this id' }, 404)
        end
      end

      desc 'Change author of an article'
      params do
        requires :id, type: Integer, desc: 'Article ID'
        requires :author, type: String, desc: 'New author name'
      end
      put ':id/author' do
        article = Article.find_by(id: params[:id])
        if article
          article.update(author: params[:author])
          article
        else
          error!({ message: 'No article exist with this id' }, 404)
        end
      end
    end
  end
end
