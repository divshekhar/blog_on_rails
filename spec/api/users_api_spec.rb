# spec/requests/api/v1/users_spec.rb
require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe 'Api::Users', type: :request do
  describe 'GET /api/v1/users' do
    it 'returns all users' do
      create_list(:user, 3)
      get '/api/users'
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'POST /api/users/signup' do
    let(:valid_params) { { email: 'test@example.com', password: 'password' } }

    it 'signs up a new user' do
      post '/api/users/signup', params: valid_params
      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)['message']).to eq('User signed up successfully')
    end

    it 'returns an error if user already exists' do
      create(:user, email: 'test@example.com')
      post '/api/users/signup', params: valid_params
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)['message']).to eq('Email has already been taken')
    end
  end

  describe 'POST /api/users/login' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password') }
    let(:valid_params) { { email: 'test@example.com', password: 'password' } }

    it 'logs in an existing user' do
      post '/api/users/login', params: valid_params
      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)['message']).to eq('User logged in successfully')
    end

    it 'returns an error for invalid credentials' do
      post '/api/users/login', params: { email: 'test@example.com', password: 'wrongpassword' }
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)['message']).to eq('Invalid email or password')
    end
  end
end
