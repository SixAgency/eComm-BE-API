
every '0 4,10,16,22 * * * *' do
            rake 'spree_braintree_vzero:update_states'
          end