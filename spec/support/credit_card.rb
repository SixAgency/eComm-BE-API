FactoryGirl.define do
  factory :square_credit_card, parent: :credit_card do
    verification_value 123
    month 12
    encrypted_data 'test-nonce'
    year { 1.year.from_now.year }
    number '4111111111111111'
    name 'Spree Commerce'
    association(:payment_method, factory: :square_payment_method)
  end

  factory :square_payment_method, class: Spree::Gateway::SquareUpGateway do
    name 'Square Credit Card'

    after(:create) do |c|
      c.set_preference(:application_id, 'application-id')
      c.set_preference(:access_token,   'access_token')
    end
  end
end
