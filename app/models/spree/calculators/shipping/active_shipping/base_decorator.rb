require "box_packer"

Spree::Calculator::Shipping::ActiveShipping::Base.class_eval do

private
  def build_location address
    ::ActiveShipping::Location.new(country: address.country.iso,
                                   state: fetch_best_state_from_address(address),
                                   city: address.city,
                                   zip: address.zipcode,
                                   address_type: 'commercial')
  end

  def convert_package_to_dimendions_weight_value_array(package)
    multiplier = Spree::ActiveShipping::Config[:unit_multiplier]
    default_weight = Spree::ActiveShipping::Config[:default_weight]
    max_weight = get_max_weight(package)

    items = package.contents.map do |content_item|
      item_weight = content_item.variant.weight.to_f
      item_weight = default_weight if item_weight <= 0
      item_weight *= multiplier

      if max_weight <= 0 || item_weight < max_weight
        [[content_item.variant.depth.to_f, content_item.variant.width.to_f, content_item.variant.height.to_f], item_weight.to_f, content_item.variant.price.to_f]
      else
        raise Spree::ShippingError.new("#{I18n.t(:shipping_error)}: The maximum per package weight for the selected service from the selected country is #{max_weight} ounces.")
      end
    end
    items
  end

  def load_boxes()
    boxes = JSON.parse(Spree::ActiveShipping::Config[:boxes]) rescue []
    multiplier = Spree::ActiveShipping::Config[:unit_multiplier]

    boxes = boxes.map do |dimensions, weight, weight_limit|
      [dimensions, weight * multiplier, weight_limit * multiplier]
    end
    boxes
  end

  def packages(package)
    units = Spree::ActiveShipping::Config[:units].to_sym
    boxes = load_boxes()
    packages = []


    if boxes.any?
      packer = BoxPacker::Packer.new
      items = convert_package_to_dimendions_weight_value_array(package)

      boxes.each do |dimensions, weight, weight_limit|
        packer.add_container(dimensions: dimensions, weight: weight, weight_limit: weight_limit)
      end
      items.each do |dimensions, weight, value|
        packer.add_item(dimensions: dimensions, weight: weight, value: value)
      end

      packer.pack()
      options = {units: units}
      packer.packages.each do |package|
        options[:insured_value] = package.value if Spree::ActiveShipping::Config[:request_insurance_to_be_included]
        packages << ::ActiveShipping::Package.new(package.weight, package.dimensions, options)
      end

      packer.unpackable_items.each do |item|
        options[:insured_value] = item.value if Spree::ActiveShipping::Config[:request_insurance_to_be_included]
        packages << ::ActiveShipping::Package.new(item.weights, item.dimensions, options)
      end
    else
      weights = convert_package_to_weights_array(package)
      max_weight = get_max_weight(package)
      dimensions = convert_package_to_dimensions_array(package)
      item_specific_packages = convert_package_to_item_packages_array(package)

      if max_weight <= 0
        packages << ::ActiveShipping::Package.new(weights.sum, dimensions, units: units)
      else
        package_weight = 0
        weights.each do |content_weight|
          if package_weight + content_weight <= max_weight
            package_weight += content_weight
          else
            packages << ::ActiveShipping::Package.new(package_weight, dimensions, units: units)
            package_weight = content_weight
          end
        end
        packages << ::ActiveShipping::Package.new(package_weight, dimensions, units: units) if package_weight > 0
      end

      item_specific_packages.each do |package|
        packages << ::ActiveShipping::Package.new(package.at(0), [package.at(1), package.at(2), package.at(3)], units: :imperial)
      end
    end

    packages
  end
end