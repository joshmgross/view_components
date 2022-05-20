# frozen_string_literal: true

module Primer
  module Alpha
    class Checkbox < Primer::Component
      status :alpha

      def initialize(
        label_text: nil,
        caption: nil,
        input_id: nil,
        input_name: nil,
        visually_hide_label: false,
        disabled: false,
        checked: false,
        type: "text",

        **system_arguments
      )
        @system_arguments = system_arguments
        @system_arguments[:tag] = :div
        @label_text = label_text
        @caption = caption
        @input_id = input_id
        @input_name = input_name || input_id
        @visually_hide_label = visually_hide_label ? "sr-only" : nil
        @disabled = disabled ? "disabled" : nil
        @checked = checked ? "checked" : nil
        @type = type
        @form_group_classes = class_names(
          "FormGroup",
          "FormGroup--checkbox",
          "FormControl-caption"
        )
        @form_control_classes = class_names(
          "FormControl",
          "FormControl--checkbox"
        )
      end
    end
  end
end
