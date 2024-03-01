require 'rails_helper'

RSpec.describe 'Articles API', type: :request do
  # Initialize the test data
  let!(:articles) do
    create_list(:article, 10)
  end
  let(:article_id) { articles.first.id }

  describe 'GET /articles' do
    # Make a request before each example
    before :each do
      # puts articles.pluck(:id).to_s
      # puts Article.pluck(:id).to_s
      get '/api/articles'
    end

    it 'returns articles' do
      expect(JSON.parse(response.body)).not_to be_empty
      expect(JSON.parse(response.body).size).to eq(10)
      expect(JSON.parse(response.body).map {|x| x['author']}).to match_array(Article.pluck(:author))
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
    let!(:article) { create(:article) }

    it 'updates the author of an article' do
      put "/api/articles/#{article.id}/author", params: { author: 'New Author' }
      expect(response).to have_http_status(200)
      expect(article.reload.author).to eq('New Author')
    end

    it 'returns an error if the article is not found' do
      put '/api/articles/999/author', params: { author: 'New Author' }
      expect(response).to have_http_status(404)
    end
  end
end
