Spree::Api::V1::OrdersController.send :include,
                                      OrderMailers, CurrentApiUserInAddress,
                                      CalculateShipping, Spree::Core::ControllerHelpers::Order
