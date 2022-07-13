

class Component
  attr_reader :classes
  STYLES_MAPPING = {
    propA: {
      valueA: "propA-valueA",
      valueB: "propA-valueB",
      DEFAULT: :valueA,
    },
    propB: {
      narrow: {
        valueA: "propB-narrow-valueA",
        valueB: "propB-narrow-valueB",
        DEFAULT: :valueA,
      },
      regular: {
        valueA: "propB-regular-valueA",
        valueB: "propB-regular-valueB",
        DEFAULT: :valueA,
      },
    }, 
    propC: {
      valueA: "propC-valueA",
      valueB: "propC-valueB",
      DEFAULT: :valueA,
    },

    placement: {
      viewport: {
        full: "p-v-f",
        center: "p-v-c",
        DEFAULT: :center
      },
      anchored: {
        top: "p-a-t",
        bottom: "p-a-b",
      },
      DEFAULT: :viewport
    },

    # complex: {
    #   propC1: {
    #     opt1: "c1-opt1",
    #     opt2: "c1-opt2",
    #     opt3: "c1-opt3"
    #   },
    #   propC2: {
    #     opt1: "c2-opt1",
    #     opt2: "c2-opt2",
    #     opt3: "c2-opt3",
    #     DEFAULT: :opt2
    #   },
    #   propC3: {
    #     opt1: "opt1",
    #     opt2: "opt2",
    #     opt3: "opt3"
    #   },
    #   DEFAULT: :propC2
    # }
  }

  def initialize(placement:, propA: nil, propB: nil, propC: nil, complex: nil)
    @classes = {
      propA: get_style_map(STYLES_MAPPING, :propA, propA),
      propB: get_responsive_styles(STYLES_MAPPING, :propB, propB),
      placement: get_style_map(STYLES_MAPPING, :placement, placement),
      complex: get_style_map(STYLES_MAPPING, :complex, complex),
    }
  end

  def get_style_map(map, property, value)
    return "" unless map.key?(property)

    puts ["##", property, value].inspect

    current_map = map[property]
    case value
    when Hash
      class_list = []
      value.each do |inner_prop, inner_value|
        class_list << get_style_map(current_map, inner_prop, inner_value)
      end
      class_list.compact.join(" ")
    when Symbol
      result = get_style_map_property(current_map, value)
      if result.is_a? Hash
        get_style_map(result, value, nil)
      else
        result
      end
    else
      if current_map.key?(:DEFAULT)
        get_style_map(map, property, current_map[:DEFAULT])
      else
        ""
      end
    end
  end

  def get_responsive_styles(map, property, value)
    return "" unless map.key?(property)

    current_map = map[property]
    return "" if current_map.nil? || current_map.empty?

    class_list = []
    current_map.each_key do |key|
      current_value = value.nil? ? nil : value[key]
      class_list << get_style_map_property(current_map[key], current_value)
    end
    class_list.compact.join(" ")
  end

  def get_style_map_property(map, value)
    puts ["&", map, value].inspect
    if value.nil?
      return "" unless map.key?(:DEFAULT)

      map[map[:DEFAULT]]
    else
      map[value]
    end
  end
end

a = Component.new(
  propA: :valueB,

  propC: nil,

  placement: {
    viewport: :full,
  },
  # complex: {
  #   propC1: :opt1,
  #   propC2: :opt3,
  #   propC3: :opt2,
  # }
)

classes = {
  propA: "propA-valueA",
  propB: "propB-narrow-valueA propB-regular-valueB",
  propC: "propC-valueA",
  placement: "Placement-narrow-viewport-full Placement-regular-anchored-bottom",
}

puts a.classes




