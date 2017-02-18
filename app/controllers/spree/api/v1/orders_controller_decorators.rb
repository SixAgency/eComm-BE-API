Spree::Api::V1::OrdersController.send :include,
                                      OrderMailers, CurrentApiUserInAddress,
                                      Spree::Core::ControllerHelpers::Order
