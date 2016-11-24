object @image
attributes *image_attributes
attributes :viewable_type, :viewable_id
Spree::Image.attachment_definitions[:attachment][:styles].each do |k,v|
  node("#{k}_url") { |i| "#{EComm::Config.asset_host}#{i.attachment.url(k)}" }
end