Rails.application.routes.draw do

  get 'welcome/index'

  resource :notification

  root 'welcome#index'

end
