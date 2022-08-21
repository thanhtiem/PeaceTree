Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'authentication/sessions',
    registrations: 'authentication/registrations'
  }

  namespace :leader do
    root 'home#index'
  end

  root 'leader/home#index'
end
