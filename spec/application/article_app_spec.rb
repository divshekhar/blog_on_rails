require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe 'Articles Application', type: :application do
  let!(:article) { create(:article) }

  describe '#check_article' do
    context 'when article is nil' do
      let(:article_app) { ArticleApp.new(nil) }

      it 'returns an error message with a 404 status code' do
        expect { article_app.check_article }.to raise_error(ActiveRecord::RecordNotFound) do |error|
          expect(error.message).to include('No article exist with this id')
        end
      end
    end

    context 'when article is not nil' do
      let(:article_app) { ArticleApp.new(article)}

      it 'returns the article' do
        allow(article_app).to receive(:article).and_return(article)
        expect(article_app.check_article).to eq(article)
      end
    end
  end
end