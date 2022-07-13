# frozen_string_literal: true

require "securerandom"

# narrow (- 768)
# regular (768 - 1440)
# wide (1440 - )

# prop: { regular: :medium }
#  prop: narrow: default
#  prop: regular: :medium
#  prop: wide: :medium

# <div class="Prop-default-whenNarrow Prop-medium-whenRegular Prop-medium-whenWide"></div>

module Primer
  module Alpha
    module Overlays
      # An overlay is a flexible floating surface, used to display transient content such as menus, selection options, dialogs, and more.
      class OverlayBase < Primer::Component
        include Primer::Alpha::Overlays::StyleMapHelper

        status :alpha

        renders_one :overlay_content

        STYLE_MAPPING = {
          backdrop: {
            narrow: {
              visible: "Overlay-backdrop--visible",
              transparent: "Overlay-backdrop--transparent",
              none: "",
              DEFAULT: :visible
            },
            regular: {

            }
          },

          motion: {
            auto: "Overlay-content--motion-auto",
            none: "",
            DEFAULT: :auto
          },

          placement: {
            viewport: {
              top: "Overlay-wrapper--top",
              left: "Overlay-wrapper--left",
              right: "Overlay-wrapper--right",
              bottom: "Overlay-wrapper--botom",
              full: "Overlay-wrapper--full",
              center: "Overlay-wrapper--center",
              DEFAULT: :center
            }
          },

          width: {
            auto: "Overlay-content--width-auto",
            xsmall: "Overlay-content--width-xsmall",
            small: "Overlay-content--width-small",
            medium: "Overlay-content--width-medium",
            large: "Overlay-content--width-large",
            xlarge: "Overlay-content--width-xlarge",
            xxlarge: "Overlay-content--width-xxlarge",
            DEFAULT: :auto
          },

          height: {
            auto: "Overlay-content--height-auto",
            xsmall: "Overlay-content--height-xsmall",
            small: "Overlay-content--height-small",
            medium: "Overlay-content--height-medium",
            large: "Overlay-content--height-large",
            xlarge: "Overlay-content--height-xlarge",
            DEFAULT: :auto
          }
        }.freeze

        PROPERTY_SPACE = {
          backdrop: [:visible, :transparent, :none],
          motion: [:auto, :none],
          placement: {
            viewport: [:top, :left, :right, :bottom, :full, :center],
            anchored: [] # TBD
          },
          open: true,
          width: [:auto, :xsmall, :small, :medium, :large, :xlarge, :xxlarge],
          height: [:auto, :xsmall, :small, :medium, :large, :xlarge],
        }
        # backdrop
        # - visible
        # - transparent
        # - none
        # motion
        # - auto
        # - none
        # placement
        # - viewport
        #   - top, left, right, bottom, full, center
        # - anchored
        #   - [directions]
        # open/dismiss behavior
        #   - open: boolean
        #   - API client-side:
        #     - open
        #     - dismiss
        # sizing
        # - width: auto, xsmall, small, medium, large, xlarge, xxlarge
        # - height: auto, xsmall, small, medium, large, xlarge

        def initialize(backdrop: nil, motion: nil, placement: nil, open: false, width: nil, height: nil)
          @backdrop = backdrop
          @placement = placement
          @open = open

          @classes = {
            backdrop: get_style_map(STYLE_MAPPING, :backdrop, backdrop),
            motion: get_style_map(STYLE_MAPPING, :motion, motion),
            width: get_style_map(STYLE_MAPPING, :width, width),
            height: get_style_map(STYLE_MAPPING, :height, height)
          }
        end

        def open?
          @open
        end

        # def get_style(property, value)
        #   get_mapped_style(STYLE_MAPPING, property, value)
        # end

        # def get_mapped_style(map, property, value)
        #   if map.key?(property)
        #     current_map = map[property]
        #     case current_map
        #     when Hash
        #       get_mapped_style
        #     when Hash
        #       class_name.each do |key, val|
        #         classes << key if val
        #       end
        #   end
        #   current_map = map[property]


        #   map = STYLE_MAPPING[property]
        #   if map.key?(value)
        #     map[value]
        #   else
        #     map[map[:DEFAULT]]
        #   end
        # end
      end
    end
  end
end


#