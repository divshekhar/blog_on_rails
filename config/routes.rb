Rails.application.routes.draw do
  mount Api::Articles => '/'
  mount Api::Users => '/'
end
