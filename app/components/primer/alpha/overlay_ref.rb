# frozen_string_literal: true

require "securerandom"

module Overlay
  # overlay ref!
  class OverlayComponentRef < ViewComponent::Base
    DEFAULT_VARIANT_REGULAR = "Overlay-backdrop--center"
    VARIANT_REGULAR_MAPPINGS = {
      DEFAULT_VARIANT_REGULAR => "Overlay-backdrop--center",
      :center => "Overlay-backdrop--center",
      :anchor => "Overlay-backdrop--anchor",
      :side => "Overlay-backdrop--side",
      :full => "Overlay-backdrop--full",
      nil => ""
    }.freeze
    VARIANT_REGULAR_OPTIONS = VARIANT_REGULAR_MAPPINGS.keys

    DEFAULT_VARIANT_NARROW = "Overlay-backdrop--center-whenNarrow"
    VARIANT_NARROW_MAPPINGS = {
      DEFAULT_VARIANT_NARROW => "Overlay-backdrop--center-whenNarrow",
      :center => "Overlay-backdrop--center-whenNarrow",
      :anchor => "Overlay-backdrop--anchor-whenNarrow",
      :side => "Overlay-backdrop--side-whenNarrow",
      :full => "Overlay-backdrop--full-whenNarrow",
      nil => ""
    }.freeze
    VARIANT_NARROW_OPTIONS = VARIANT_NARROW_MAPPINGS.keys

    DEFAULT_PLACEMENT_REGULAR = nil
    PLACEMENT_REGULAR_MAPPINGS = {
      DEFAULT_PLACEMENT_REGULAR => nil,
      :left => "Overlay-backdrop--placement-left",
      :right => "Overlay-backdrop--placement-right",
      :top => "Overlay-backdrop--placement-top",
      :bottom => "Overlay-backdrop--placement-bottom"
    }.freeze
    PLACEMENT_REGULAR_OPTIONS = PLACEMENT_REGULAR_MAPPINGS.keys

    DEFAULT_PLACEMENT_NARROW = nil
    PLACEMENT_NARROW_MAPPINGS = {
      DEFAULT_PLACEMENT_NARROW => nil,
      :left => "Overlay-backdrop--placement-left-whenNarrow",
      :right => "Overlay-backdrop--placement-right-whenNarrow",
      :top => "Overlay-backdrop--placement-top-whenNarrow",
      :bottom => "Overlay-backdrop--placement-bottom-whenNarrow"
    }.freeze
    PLACEMENT_NARROW_OPTIONS = PLACEMENT_NARROW_MAPPINGS.keys

    DEFAULT_HEADER_VARIANT = :medium
    HEADER_VARIANT_MAPPINGS = {
      DEFAULT_HEADER_VARIANT => "",
      :large => "Overlay-header--large",
      :custom => "Overlay-header--custom"
    }.freeze
    HEADER_VARIANT_OPTIONS = HEADER_VARIANT_MAPPINGS.keys

    DEFAULT_HEIGHT = :auto
    HEIGHT_MAPPINGS = {
      DEFAULT_HEIGHT => "Overlay--height-auto",
      :xsmall => "Overlay--height-xsmall",
      :small => "Overlay--height-small",
      :medium => "Overlay--height-medium",
      :large => "Overlay--height-large",
      :xlarge => "Overlay--height-xlarge"
    }.freeze
    HEIGHT_OPTIONS = HEIGHT_MAPPINGS.keys

    DEFAULT_WIDTH = :medium
    WIDTH_MAPPINGS = {
      :auto => "Overlay--width-auto",
      :xsmall => "Overlay--width-xsmall", 
      :small => "Overlay--width-small",
      DEFAULT_WIDTH => "Overlay--width-medium",
      :large => "Overlay--width-large",
      :xlarge => "Overlay--width-xlarge",
      :xxlarge => "Overlay--width-xxlarge"
    }.freeze
    WIDTH_OPTIONS = WIDTH_MAPPINGS.keys


    renders_one :body
    renders_one :header
    renders_one :sub_header

    def initialize(
      title: nil,
      description: nil,
      overlay_id: "overlay-#{SecureRandom.hex(4)}",
      open: false,
      width: DEFAULT_WIDTH,
      height: DEFAULT_HEIGHT,
      variant: { narrow: DEFAULT_VARIANT_NARROW, regular: DEFAULT_VARIANT_REGULAR },
      placement: { narrow: DEFAULT_PLACEMENT_NARROW, regular: DEFAULT_PLACEMENT_REGULAR },
      header_variant: DEFAULT_HEADER_VARIANT
    )
      @title = title
      @description = description
      @open = open

      @width = width
      @height = height

      @variant = variant
      @placement = placement
      @header_variant = header_variant

      @id = overlay_id.to_s
      @header_id = "#{overlay_id}-header"

      @description_id = "#{overlay_id}-description" if @description.present?

      # styles
      @backdrop_classes = class_names(
        VARIANT_REGULAR_MAPPINGS[variant[:regular]],
        VARIANT_NARROW_MAPPINGS[variant[:narrow]],
        PLACEMENT_REGULAR_MAPPINGS[ placement[:regular]],
        PLACEMENT_NARROW_MAPPINGS[placement[:narrow]],
        "Overlay--visibilityHidden": !open,
      )

      @overlay_classes = class_names(
        WIDTH_MAPPINGS[width],
        HEIGHT_MAPPINGS[height],
      )

      @header_classes = class_names(
        HEADER_VARIANT_MAPPINGS[header_variant]
      )

      @body_classes = "Overlay-body--paddingNone"
    end


    private

    # pulled from Primer::ClassNameHelper::class_names
    def class_names(*args)
      [].tap do |classes|
        args.each do |class_name|
          case class_name
          when String
            classes << class_name if class_name.present?
          when Hash
            class_name.each do |key, val|
              classes << key if val
            end
          when Array
            classes << class_names(*class_name).presence
          end
        end

        classes.compact!
        classes.uniq!
      end.join(" ")
    end
  end
end