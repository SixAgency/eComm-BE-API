Rails.application.routes.draw do

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, at: '/'
          # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  Spree::Core::Engine.add_routes do
    namespace :api, defaults: { format: 'json' } do
      namespace :v1 do
        resources :addresses, except: [:new, :edit], controller: :user_addresses do
          collection do
            patch 'default', to: 'user_addresses#default_resources'
          end
        end

        resource :contact, only:[:create]

        resources :products, only: [], controller: '/spree/admin/products' do
          get :related, on: :member
          resources :relations, controller: '/spree/api/relations' do
            collection do
              post :update_positions
            end
          end
        end

        resources :orders, only: [] do
          patch :calculate_shipping, on: :member
          put   :remove_promotions, on: :member
        end

        resources :checkouts, only: [:update] do
          member do
            put :reset
          end
        end

        resources :store_credit_events, only: [] do
          collection do
            get :mine
          end
        end

        resources :gift_cards, only: [] do
          collection do
            post :redeem
          end
        end
      end
    end

    namespace :admin do
      resources :users, only: [] do
        resources :gift_cards, only: [] do
          collection do
            get :lookup
            post :redeem
          end
        end

        collection do
          resources :gift_cards, only: [:index]
        end
      end

      resources :orders, only: [] do
        resources :gift_cards, only: [:edit, :update] do
          member do
            put :send_email
            put :deactivate
          end
        end
      end
    end
  end

end
