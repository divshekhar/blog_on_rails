require_relative '../app/api/articles_api.rb'

Rails.application.routes.draw do
  mount BlogOnRails::ArticlesApi => '/'
end
