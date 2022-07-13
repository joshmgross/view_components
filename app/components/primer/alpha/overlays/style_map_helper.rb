# frozen_string_literal: true

module Primer
  module Alpha
    module Overlays
      # style map helper
      module StyleMapHelper
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
    end
  end
end