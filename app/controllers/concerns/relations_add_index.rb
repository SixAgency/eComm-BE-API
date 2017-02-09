module RelationsAddIndex
  extend ActiveSupport::Concern

  def self.included(base)
    base.class_eval do
      def index
        render json: product_and_relations
      end

      private

      def product_and_relations
        relations =  load_data.relations.includes(:related_to)
        {
          product: {
            id: load_data.id,
            relations: relations.as_json(include: :related_to)
          }
        }
      end
    end
  end
end