module PaymentWithRefunds
  def self.included(base)
    base.class_eval do
      def index
        @payments = @order
                        .payments.ransack(params[:q])
                        .result
                        .page(params[:page])
                        .per(params[:per_page])
                        .includes(refunds: [
                                               :id, :amount, :refund_reason_id
                                           ])
        respond_with(@payments)
      end
    end
  end
end
