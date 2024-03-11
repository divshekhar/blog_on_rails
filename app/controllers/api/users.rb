module Api
  class Users < Grape::API
    version 'v1', using: :header, vendor: 'api'
    format :json
    prefix :api

    resource :users do
      desc 'Get all users'
      get do
        User.all
      end

      desc 'Sign up'
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User password'
      end
      post 'signup' do
        user = User.new(email: params[:email], password: params[:password], password_confirmation: params[:password])
        if user.save
          SendVerificationEmailJob.perform_async(user.id, "jlasjd")
          { message: 'User signed up successfully' }
        else
          error!({ message: user.errors.full_messages.join(', ') }, 400)
        end
      end

      desc 'Log in'
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User password'
      end
      post 'login' do
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          { message: 'User logged in successfully' }
        else
          error!({ message: 'Invalid email or password' }, 401)
        end
      end
    end
  end
end