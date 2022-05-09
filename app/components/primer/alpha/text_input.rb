# frozen_string_literal: true

module Primer
  module Alpha
    # Add a general description of component here
    # Add additional usage considerations or best practices that may aid the user to use the component correctly.
    # @accessibility Add any accessibility considerations
    class TextInput < Primer::Component
      status :alpha

      DEFAULT_SIZE = :medium
      SIZE_MAPPINGS = {
        :small => "FormControl--small",
        :medium => "FormControl--medium",
        :large => "FormControl--large",
        DEFAULT_SIZE => "FormControl--medium"
      }.freeze
      SIZE_OPTIONS = SIZE_MAPPINGS.keys

      DEFAULT_LABEL_POSITION = :block
      LABEL_POSITION_MAPPINGS = {
        :inline => "FormGroup--inline",
        DEFAULT_LABEL_POSITION => ""
      }.freeze
      LABEL_POSITION_OPTIONS = LABEL_POSITION_MAPPINGS.keys

      renders_one :leading_visual, types: {
        icon: lambda { |**system_arguments|
          system_arguments[:classes] = class_names("FormControl--input-leadingVisual")
          Primer::OcticonComponent.new(**system_arguments)
        }
      }

      # @example Example goes here
      #
      #   <%= render(Primer::TextInput.new) { "Example" } %>
      #
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>

      def initialize(
        label_text:,
        input_id:,
        hint_text: nil,
        input_name: nil,
        placeholder: nil,
        show_clear_button: false,
        visually_hide_label: nil,
        size: DEFAULT_SIZE,
        label_position: DEFAULT_LABEL_POSITION,
        full_width: false,
        disabled: false,
        invalid: false,
        type: "text",

        **system_arguments
      )
        @system_arguments = system_arguments
        @system_arguments[:tag] = :div
        @label_text = label_text
        @hint_text = hint_text
        @input_id = input_id
        @input_name = input_name || input_id
        @placeholder = placeholder
        @visually_hide_label = visually_hide_label ? "sr-only" : nil
        @show_clear_button = show_clear_button
        @disabled = disabled ? "disabled" : nil
        @invalid = invalid ? "true" : nil
        @size = size
        @full_width = full_width
        @label_position = label_position
        @type = type
        @field_wrap_classes = class_names(
          "FormControl-fieldWrap",
          "FormControl-fieldWrap--input",
          SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, @size, DEFAULT_SIZE)],
          "FormControl-fieldWrap--disabled": disabled,
          "FormControl-fieldWrap--invalid": invalid
        )
        @form_group_classes = class_names(
          LABEL_POSITION_MAPPINGS[fetch_or_fallback(LABEL_POSITION_OPTIONS, @label_position, DEFAULT_LABEL_POSITION)],
          "FormGroup",
          "FormGroup--fullWidth": full_width
        )
        @form_control_classes = class_names(
          "FormControl",
          "FormControl--input",
          @full_width && "FormControl--fullWidth",
          SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, @size, DEFAULT_SIZE)]
        )
      end
    end
  end
end
