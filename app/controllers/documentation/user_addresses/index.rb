module Documentation
  module UserAddresses
    module Index
      extend ActiveSupport::Concern

      included do
        swagger_api :index do
          summary "Fetches all User addresses"
          notes "This lists all the active user addresses"
          response :ok, "Success"
        end
      end
    end
  end
end

