module Api
  class Articles < Grape::API
    version 'v1', using: :header, vendor: 'api'
    format :json
    prefix :api

    helpers Api::Helpers::Articles

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
          if article.save!
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
          check_article(article)
          check_user(article.user_id, params[:user_id])
          delete_article article
        end

        desc 'Change visibility of an article'
        params do
          requires :id, type: Integer, desc: 'Article ID'
          requires :user_id, type: Integer, desc: 'Current User ID'
          requires :visibility, type: Boolean, desc: 'New visibility status'
        end
        put ':id/visibility' do
          article = Article.find_by(id: params[:id])
          check_article(article)
          check_user(article.user_id, params[:user_id])
          update_article(article, :visibility => params[:visibility])
          ArticleApp.new.foo_bar
        end

        desc 'Change author of an article'
        params do
          requires :id, type: Integer, desc: 'Article ID'
          requires :user_id, type: Integer, desc: 'Current User ID'
          requires :new_user_id, type: Integer, desc: 'New author id'
        end
        put ':id/author' do
          article = Article.find_by(id: params[:id])
          check_article(article)
          check_user(article.user_id, params[:user_id])
          update_article(article, :user_id => params[:new_user_id])
        end
      end
    end
end
