Spree::Api::V1::OrdersController.send :include,
                                      OrderMailers, CalculateShipping, 
                                      Spree::Core::ControllerHelpers::Order