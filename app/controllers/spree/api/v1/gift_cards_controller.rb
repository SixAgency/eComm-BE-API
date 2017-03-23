module Spree
  module Api
    module V1
      class GiftCardsController < Spree::Api::BaseController
        before_action :remove_anonymous_user

        def redeem
          redemption_code = Spree::RedemptionCodeGenerator.format_redemption_code_for_lookup(params[:redemption_code] || "")
          @gift_card = Spree::VirtualGiftCard.active_by_redemption_code(redemption_code)

          if !@gift_card
            render status: :not_found, json: redeem_fail_response
          elsif @gift_card.redeem(@current_api_user)
            render status: :created, json: {}
          else
            render status: 422, json: redeem_fail_response
          end
        end

        private

        def redeem_fail_response
          {
              exception: "#{Spree.t('admin.gift_cards.errors.not_found')}. #{Spree.t('admin.gift_cards.errors.please_try_again')}"
          }
        end

        def remove_anonymous_user
          @current_api_user = nil if !@current_api_user.nil? && @current_api_user.id.nil?
        end
      end
    end
  end
end
