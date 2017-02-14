module RelationsAddIndex
  def self.included(base)
    base.class_eval do
      def index
        @product =  Spree::Product.includes(relations: {
            related_to:
                [
                    { master:   [:option_values, :images] },
                    { variants: [:option_values, :images] },
                    :option_types, :product_properties,
                    { classifications: :taxon }
                ]
        }).friendly.find(params[:product_id])

        respond_with(@product)
      end
    end
  end
end