Spree::StoreController.class_eval do
  before_action :mask_frontend

  def mask_frontend
    if request.path !=~ /admin/ && request.format.html?
      redirect_to admin_path and return false
    end
  end
end