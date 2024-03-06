require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe 'Articles API', type: :request do
  let!(:articles) do
    create_list(:article, 10, :with_user)
  end

  let(:article_id) do
    articles.first.id
  end

  describe 'GET /articles' do
    # Make a request before each example
    before :each do
      get '/api/articles'
    end

    it 'returns articles' do
      articles_json = JSON.parse(response.body)
      expect(articles_json).not_to be_empty
      articles_json.each do |article|
        expect(article.keys).to contain_exactly('title', 'body', 'slug', 'visibility', 'user_id')
      end
      expect(articles_json.size).to eq(10)
      expect(articles_json.map {|x| x['user_id']}).to match_array(Article.pluck(:user_id))
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /articles/:id' do
    before { get "/api/articles/#{article_id}" }

    context 'when the record exists' do
      it 'returns the article' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['id']).to eq(article_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:article_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/No article exist with this id/)

    end
  end

  describe 'PUT /articles/:id/visibility' do
    let!(:article) { create(:article) }

    it 'updates the visibility of an article' do
      put "/api/articles/#{article.id}/visibility", params: { visibility: false }
      expect(response).to have_http_status(200)
      expect(article.reload.visibility).to eq(false)
    end

    it 'returns an error if the article is not found' do
      put '/api/articles/999/visibility', params: { visibility: false }
      expect(response).to have_http_status(404)
    end
  end

  describe 'PUT /articles/:id/author' do
    before :each do
      @article = create(:article)
    end

    it 'updates the author of an article' do
      put "/api/articles/#{@article.id}/author", params: { user_id: 1 }
      expect(response).to have_http_status(200)
      expect(@article.reload.user_id).to eq(@article.user_id)
    end

    it 'returns an error if the article is not found' do
      put '/api/articles/999/author', params: { user_id: 1 }
      expect(response).to have_http_status(404)
    end
  end
  end
end

