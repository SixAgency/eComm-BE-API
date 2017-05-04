Spree::Api::V1::OrdersController.send :include,
                                      OrderMailers, CalculateShipping, RemovePromotions
                                      Spree::Core::ControllerHelpers::Order