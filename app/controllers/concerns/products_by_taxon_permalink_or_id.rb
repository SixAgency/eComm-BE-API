module ProductsByTaxonPermalinkOrId
  extend ActiveSupport::Concern

  def self.included(base)
    base.class_eval do
      def products
        # Returns the products sorted by their position with the classification
        # Products#index does not do the sorting.
        taxon = params[:id].nil? ? taxon_by_permalink : taxon_by_id
        @products = taxon.products.ransack(params[:q]).result
        @products = @products.page(params[:page]).per(params[:per_page] || 500)
        render "spree/api/v1/products/index"
      end

      private

      def taxon_by_id
        Spree::Taxon.find_by_id(params[:id])
      end

      def taxon_by_permalink
        Spree::Taxon.find_by_permalink(params[:permalink])
      end
    end
  end
end