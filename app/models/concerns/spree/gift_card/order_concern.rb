module Spree::GiftCard::OrderConcern

  def self.included(base)
    # base.state_machine.before_transition to: :confirm, do: :add_store_credit_payments
    base.state_machine.after_transition to: :complete, do: :send_gift_card_emails
    base.has_many :gift_cards, through: :line_items
    base.prepend(InstanceMethods)
    base.include Spree::Order::StoreCredit
  end

  module InstanceMethods
    def gift_card_match(line_item, options)
      return true unless line_item.gift_card?
      return true unless options["gift_card_details"]
      line_item.gift_cards.any? do |gift_card|
        gc_detail_set = gift_card.details.stringify_keys.except("send_email_at").to_set
        options_set = options["gift_card_details"].except("send_email_at").to_set
        gc_detail_set.superset?(options_set)
      end
    end

    def finalize!
      super
      inventory_units = self.inventory_units
      gift_cards.each_with_index do |gift_card, index|
        gift_card.make_redeemable!(purchaser: user, inventory_unit: inventory_units[index])
      end
    end

    def send_gift_card_emails
      gift_cards.each do |gift_card|
        if gift_card.send_email_at.nil? || gift_card.send_email_at <= Time.now.utc
          gift_card.send_email
        end
      end
    end

    private

    def after_cancel
      super

      # Free up authorized store credits
      payments.store_credits.pending.each { |payment| payment.void! }

      # payment_state has to be updated because after_cancel on
      # super does an update_column on the payment_state to set
      # it to 'credit_owed' but that is not correct if the
      # payments are captured store credits that get totally refunded

      reload
      updater.update_payment_state
      updater.persist_totals
    end

    def update_params_payment_source
      if @updating_params[:payment_source].present?
        source_params = @updating_params.
            delete(:payment_source)[@updating_params[:order][:payments_attributes].
            first[:payment_method_id].to_s]

        if source_params
          @updating_params[:order][:payments_attributes].first[:source_attributes] = source_params
        end
      end

      if @updating_params[:order] && (@updating_params[:order][:payments_attributes] ||
          @updating_params[:order][:existing_card])
        @updating_params[:order][:payments_attributes] ||= [{}]
        @updating_params[:order][:payments_attributes].first[:amount] = order_total_after_store_credit
      end
    end
  end
end
