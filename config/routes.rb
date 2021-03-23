Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  resources :promotions, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    post 'generate_coupons', on: :member
  end

  resources :product_categories, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :coupons, only: [] do
    post 'disable', on: :member
  end

end
