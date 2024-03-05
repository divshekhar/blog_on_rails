require_relative '../app/api/articles_api.rb'
require_relative '../app/api/users_api.rb'

Rails.application.routes.draw do
  mount API::Articles => '/'
  mount API::Users => '/'
end
