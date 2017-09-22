module CsvFormat

  def index
    super

    respond_to do |format|
      format.html
      format.csv { send_data Spree::Order.to_csv(@search.result(distinct: true)), filename: "orders-#{Date.today}.csv" }
    end
  end
end

