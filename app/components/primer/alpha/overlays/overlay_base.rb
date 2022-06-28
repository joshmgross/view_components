# frozen_string_literal: true

require "securerandom"

module Primer
  module Alpha
    module Overlays
      # An overlay is a flexible floating surface, used to display transient content such as menus, selection options, dialogs, and more.
      class OverlayBase < Primer::Component
        status :alpha

        renders_one :overlay_content

        STYLE_MAPPING = {
          backdrop: {
            visible: "Overlay-backdrop--visible",
            transparent: "Overlay-backdrop--transparent",
            none: "",
            DEFAULT: :visible
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
            backdrop: get_mapped_style(:backdrop, backdrop),
            motion: get_mapped_style(:motion, motion),
            width: get_mapped_style(:width, width),
            height: get_mapped_style(:height, height)
          }
        end

        def display_backdrop?
          @backdrop != :none
        end

        def open?
          @open
        end

        def get_mapped_style(property, value)
          "" unless map.key?(property)

          if map.key?(value)
            map[value]
          else
            map[STYLE_MAPPING[property][:DEFAULT]]
          end
        end
      end
    end
  end
end
