Spree::Api::V1::OrdersController.send :include, OrderMailers,
                                      Spree::Core::ControllerHelpers::Order,  BraintreeApiIntegration
