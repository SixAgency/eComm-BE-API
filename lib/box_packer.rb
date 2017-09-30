module BoxPacker

  class Item
    attr_reader :dimensions, :weight, :value

    def initialize(dimensions:, weight:, value:)
      @dimensions = dimensions.sort.reverse
      @weight = weight
      @value = value
    end

    def volume
      @dimensions.inject(:*)
    end
  end

  class Package
    attr_reader :items
    attr_accessor :unpacked_items

    def initialize(container:)
      @container = container
      @items = []
      @unpacked_items = []
    end

    def fit?(item)
      item.volume <= self.empty_space and
      item.weight <= @container.weight_limit - @items.sum(&:weight)
    end

    def place(item)
      @items << item
    end

    def empty_space
      self.volume - self.items.sum(&:volume)
    end

    def efficiency
      @items.count * 1.0 / (@unpacked_items.count + @items.count)
    end

    def weight
      @items.sum(&:weight) + @container.weight
    end

    def value
      @items.sum(&:value)
    end

    def dimensions
      @container.dimensions
    end

    def volume
      @container.volume
    end
  end

  class Container
    attr_reader :dimensions, :weight, :weight_limit

    def initialize(dimensions:, weight:, weight_limit:)
      @dimensions = dimensions.sort.reverse
      @weight = weight
      @weight_limit = weight_limit
    end

    def volume
      @dimensions.inject(:*)
    end

    def pack(items)
      package = BoxPacker::Package.new(container: self)

      items.sort_by(&:volume).reverse.each do |item|
        if package.fit?(item)
          package.place(item)
        else
          package.unpacked_items << item
        end
      end

      package
    end
  end

  class Packer
    attr_reader :packages, :unpackable_items

    def initialize
      @containers = []
      @items = []
      @packages = []
      @unpackable_items = []
    end

    def add_container(dimensions:, weight:, weight_limit:)
      @containers << BoxPacker::Container.new(dimensions: dimensions, weight: weight, weight_limit: weight_limit)
    end

    def add_item(dimensions:, weight:, value:)
      @items << BoxPacker::Item.new(dimensions: dimensions, weight: weight, value: value)
    end

    def pack()
      @packages = []
      @unpackable_items = []

      if @containers.empty?
        @unpackable_items += @items
        @items.clear
      end

      until @items.empty?
        possible_packages = []

        @containers.sort_by(&:volume).reverse.each do |container|
          possible_packages << container.pack(@items)
        end

        best_packages = possible_packages.group_by(&:efficiency).max.last
        best_package = best_packages.min_by(&:volume)

        unless best_package.efficiency == 0
          @packages << best_package
          @items -= best_package.items
        else
          @unpackable_items += @items
          @items.clear
        end
      end
    end
  end
end
