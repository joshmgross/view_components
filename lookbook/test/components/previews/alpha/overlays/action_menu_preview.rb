# frozen_string_literal: true

module Alpha
  module Overlays
    # @label ActionMenu
    class ActionMenuPreview < ViewComponent::Preview
      # @label Playground
      #
      # @param title [String] text
      # @param description [String] text
      # @param overlay_id [String] text
      # @param show_header_divider [Boolean] toggle
      # @param show_footer_divider [Boolean] toggle
      # @param show_close_button [Boolean] toggle
      # @param footer_content_align select [start, center, end]
      # @param header_variant select [medium, large]
      # @param body_padding_variant select [normal, condensed, none]
      # @param motion select [scale_fade, none]
      # @param width select [auto, small, medium, large, xlarge, xxlarge]
      # @param height select [auto, xsmall, small, medium, large, xlarge]
      # @param variant_narrow select [center, anchor, side, full]
      # @param variant_regular select [center, anchor, side, full]
      # @param placement_narrow [Symbol] select [[Left, left], [Right, right], [Top, top], [Bottom, bottom], [Unset, unset]]
      # @param placement_regular [Symbol] select [[Left, left], [Right, right], [Top, top], [Bottom, bottom], [Unset, unset]]
      # @param open toggle
      def playground()
        render(Primer::Alpha::Overlays::ActionMenu.new)
      end
    end
  end
end
