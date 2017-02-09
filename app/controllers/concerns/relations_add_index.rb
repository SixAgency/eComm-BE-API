module RelationsAddIndex
  extend ActiveSupport::Concern

  def self.included(base)
    base.class_eval do
      def index
        render json: product_with_relations_included
      end

      private

      def product_with_relations_included
        result = {
            product: {
                id: load_data.id,
                relations: []
            }
        }

        load_data.relations.includes(:relation_type).each do |relation|
          next if relation.nil?
          result[:product][:relations] << relation.attributes
          result[:product][:relations].last[:related_to] = relation.related_to.attributes
          result[:product][:relations].last.delete(:related_to_id)
        end

        result
      end
    end
  end
end