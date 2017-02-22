object false
child(@payments => :payments) do
  extends "spree/api/v1/payments/show"
end
node(:count) { @payments.count }
node(:current_page) { params[:page].try(:to_i) || 1 }
node(:pages) { @payments.total_pages }


