class Spree::Api::V1::StoreCreditEventsController < Spree::Api::BaseController
  def mine
    @store_credit_events = current_api_user
                               .store_credit_events
                               .exposed_events
                               .page(params[:page])
                               .per(params[:per_page])
                               .reverse_chronological
  end
end