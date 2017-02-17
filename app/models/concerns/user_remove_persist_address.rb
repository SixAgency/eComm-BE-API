module UserRemovePersistAddress
  def self.included(base)
    base.class_eval do
      def persist_user_address!
      end
    end
  end
end