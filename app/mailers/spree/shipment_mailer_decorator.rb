Spree::ShipmentMailer.class_eval do
	def shipped_email(shipment, resend = false, to_internal=false)
		@shipment = shipment.respond_to?(:id) ? shipment : Spree::Shipment.find(shipment)
		@to_internal = to_internal
		subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
		subject += "#{Spree::Store.current.name} #{Spree.t('shipment_mailer.shipped_email.subject')} ##{@shipment.order.number}"
		target_email = @to_internal ? DefaultAppSettings::ORDER_EMAIL_TO : @shipment.order.email
		mail(to: target_email, from: from_address, subject: subject)
	end	
end