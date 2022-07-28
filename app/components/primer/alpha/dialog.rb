# frozen_string_literal: true

module Primer
  module Alpha
    # A `Dialog` is used to remove the user from the main application flow,
    # to confirm actions, ask for disambiguation or to present small forms.
    #
    # @accessibility
    #   - **Dialog Accessible Name**: A dialog should have an accessible name,
    #   so screen readers are aware of the purpose of the dialog when it opens.
    #   Give an accessible name setting `:title`. The accessible name will be
    #   used as the main heading inside the dialog.
    #   - **Dialog unique id**: A dialog should be unique. Give a unique id
    #   setting `:dialog_id`. If no `:dialog_id` is given, a default randomize
    #   hex id is generated.
    #
    #   The combination of both `:title` and `:dialog_id` establishes an
    #   `aria-labelledby` relationship between the title and the unique id of
    #   the dialog.
    class Dialog < Primer::Component
      DEFAULT_WIDTH = :medium
      WIDTH_MAPPINGS = {
        :small => "Overlay--width-small",
        DEFAULT_WIDTH => "Overlay--width-medium",
        :large => "Overlay--width-large",
        :xlarge => "Overlay--width-xlarge",
        :xxlarge => "Overlay--width-xxlarge"
      }.freeze
      WIDTH_OPTIONS = WIDTH_MAPPINGS.keys

      # Optional button to open the dialog.
      #
      # @param system_arguments [Hash] The same arguments as <%= link_to_component(Primer::ButtonComponent) %>.
      renders_one :show_button, lambda { |**system_arguments|
        system_arguments[:classes] = class_names(
          system_arguments[:classes]
        )
        system_arguments[:id] = "dialog-show-#{@system_arguments[:id]}"
        system_arguments["data-show-dialog-id"] = @system_arguments[:id]
        system_arguments[:data] = (system_arguments[:data] || {}).merge({ "show-dialog-id": @system_arguments[:id] })
        Primer::ButtonComponent.new(**system_arguments)
      }

      # Header content.
      #
      # @param hide_divider [Boolean] If true the visual dividing line between the header and body will be hidden
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
      renders_one :header, lambda { |hide_divider: false, **system_arguments|
        if @subtitle.present?
          subtitle_id = "#{@id}-description"
        end
        Primer::Alpha::Dialog::Header.new(
          title: @title,
          subtitle: @subtitle,
          subtitle_id: subtitle_id,
          hide_divider: hide_divider,
          **system_arguments
        )
      }

      # Required body content.
      #
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
      renders_one :body, "Body"

      # Footer content.
      #
      # @param hide_divider [Boolean] If true the visual dividing line between the body and footer will be hidden
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
      renders_one :footer, lambda { |hide_divider: false, **system_arguments|
        Primer::Alpha::Dialog::Footer.new(hide_divider: hide_divider, **system_arguments)
      }

      # @example Dialog with Cancel and Submit buttons
      #   @description
      #     An ID is provided which enables wiring of the open and close buttons to the dialog.
      #   @code
      #     <%= render(Primer::Alpha::Dialog.new(
      #       title: "Dialog Example",
      #     )) do |d| %>
      #       <% d.show_button { "Show Dialog" } %>
      #       <% d.body do %>
      #         <p>Some content</p>
      #       <% end %>
      #       <% d.footer do %>
      #         <%= render(Primer::ButtonComponent.new(data: { "close-dialog-id": "my-dialog" })) { "Cancel" } %>
      #         <%= render(Primer::ButtonComponent.new(scheme: :primary)) { "Submit" } %>
      #       <% end %>
      #     <% end %>
      # @param id [String] The id of the dialog.
      # @param title [String] The title of the dialog.
      # @param subtitle [String] The subtitle of the dialog. This will also set the `aria-describedby` attribute.
      # @param width [Symbol] The width of the dialog. <%= one_of(Primer::Alpha::Dialog::WIDTH_OPTIONS) %>
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
      # @param body_padding_variant??
      def initialize(
        title:,
        subtitle: nil,
        width: DEFAULT_WIDTH,
        id: "dialog-#{(36**3 + rand(36**4)).to_s(36)}",
        **system_arguments
      )
        @system_arguments = deny_tag_argument(**system_arguments)

        @system_arguments[:tag] = "modal-dialog"
        @system_arguments[:role] = "dialog"
        @system_arguments[:id] = id.to_s
        @system_arguments[:aria] = { modal: true }
        @system_arguments[:classes] = class_names(
          "Overlay",
          WIDTH_MAPPINGS[fetch_or_fallback(WIDTH_OPTIONS, width, DEFAULT_WIDTH)],
          "Overlay--height-auto",
          "Overlay--motion-scaleFade",
          system_arguments[:classes]
        )

        @id = id.to_s
        @title = title

        @subtitle = subtitle
        if subtitle.present?
          @system_arguments[:aria].describedby ||= "#{@id}-description"
        end
      end
    end
  end
end
