require 'rails_helper'
require 'byebug'

describe Spree::Gateway::SquareUpGateway, type: :model do

  subject           { create :square_payment_method }
  let(:credit_card) { create(:square_credit_card, payment_method: subject) }
  let(:payment)     { create(:payment, source: credit_card, payment_method: subject) }

  # regression test for #3824
  describe "#create profile" do
    it "should save newly added credit card" do

    end
  end
end