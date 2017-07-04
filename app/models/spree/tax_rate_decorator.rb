Spree::TaxRate.class_eval do
  private
  def amount_for_label
    return "" unless show_rate_in_label?
    " " + ActiveSupport::NumberHelper::NumberToPercentageConverter.convert(
      amount * 100,
      locale: I18n.locale,
      precision: 3
    )
  end
end

