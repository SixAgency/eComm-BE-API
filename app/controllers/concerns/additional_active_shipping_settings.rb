module AdditionalActiveShippingSettings

  def edit
    super

    @preferences_UPS << :request_insurance_to_be_included
    @preferences_GeneralSettings << :boxes
  end

end
