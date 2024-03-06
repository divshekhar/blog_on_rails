require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe 'Article Model', type: :model do
  describe 'is valid' do
    let!(:article) { create(:article) }

    it "with valid attributes" do
      expect(article).to be_valid
    end
  end

  describe 'is not valid' do
    it "without a title" do
      article = Article.new(title: nil)
      expect(article).to_not be_valid
    end

    it "without a body" do
      article = Article.new(title: 'Title', body: nil)
      expect(article).to_not be_valid
    end

    it "without a slug" do
      article = Article.new(title: 'Title', body: 'Body', slug: nil)
      expect(article).to_not be_valid
    end

    it "without a visibility" do
      article = Article.new(title: 'Title', body: 'Body', slug: 'slug', visibility: nil)
      expect(article).to_not be_valid
    end

    it "without a user id" do
      article = Article.new(title: 'Title', body: 'Body', slug: 'slug', visibility: true, user_id: nil)
      expect(article).to_not be_valid
    end
  end
end