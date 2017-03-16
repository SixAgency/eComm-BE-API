module Spree
  module Admin
    class StoreCreditCategoriesController < ResourceController
      def index
        @store_credit_categories = collection
      end

      private

      def collection
        params[:q] ||= {}
        @search = Spree::StoreCreditCategory.ransack(params[:q])
        @collection = @search.result.page(params[:page]).per(params[:per_page])
      end

      def store_credit_category
        @store_credit_category ||= @object
      end

      def safe_params
        [:name]
      end

      def store_credit_category_params
        params.require(:store_credit_category).permit(*safe_params)
      end
    end
  end
end