# frozen_string_literal: true

module Primer
  module Beta
    # Use `Button` for actions (e.g. in forms). Use links for destinations, or moving from one page to another.
    class Button < Primer::Component
      status :beta

      DEFAULT_SCHEME = :default
      LINK_SCHEME = :link
      SCHEME_MAPPINGS = {
        DEFAULT_SCHEME => "",
        :primary => "btn-primary",
        :danger => "btn-danger",
        :outline => "btn-outline",
        :invisible => "btn-invisible",
        LINK_SCHEME => "btn-link"
      }.freeze
      SCHEME_OPTIONS = SCHEME_MAPPINGS.keys

      DEFAULT_SIZE = :medium
      SIZE_MAPPINGS = {
        :small => "btn-sm",
        DEFAULT_SIZE => ""
      }.freeze
      SIZE_OPTIONS = SIZE_MAPPINGS.keys

      # Leading visuals appear to the left of the button text.
      #
      # Use:
      #
      # - `leading_visual_icon` for a <%= link_to_component(Primer::OcticonComponent) %>.
      #
      # @param system_arguments [Hash] Same arguments as <%= link_to_component(Primer::OcticonComponent) %>.
      renders_one :leading_visual, types: {
        icon: lambda { |**system_arguments|
          system_arguments[:mr] = 2

          Primer::OcticonComponent.new(**system_arguments)
        }
      }
      alias icon leading_visual_icon # remove alias when all buttons are migrated to new slot names

      # Trailing visuals appear to the right of the button text.
      #
      # Use:
      #
      # - `trailing_visual_counter` for a <%= link_to_component(Primer::CounterComponent) %>.
      #
      # @param system_arguments [Hash] Same arguments as <%= link_to_component(Primer::CounterComponent) %>.
      renders_one :trailing_visual, types: {
        counter: lambda { |**system_arguments|
          system_arguments[:ml] = 2

          Primer::CounterComponent.new(**system_arguments)
        }
      }
      alias counter trailing_visual_counter # remove alias when all buttons are migrated to new slot names

      # `Tooltip` that appears on mouse hover or keyboard focus over the button. Use tooltips sparingly and as a last resort.
      # **Important:** This tooltip defaults to `type: :description`. In a few scenarios, `type: :label` may be more appropriate.
      # Consult the <%= link_to_component(Primer::Alpha::Tooltip) %> documentation for more information.
      #
      # @param type [Symbol] (:description) <%= one_of(Primer::Alpha::Tooltip::TYPE_OPTIONS) %>
      # @param system_arguments [Hash] Same arguments as <%= link_to_component(Primer::Alpha::Tooltip) %>.
      renders_one :tooltip, lambda { |**system_arguments|
        raise ArgumentError, "Buttons with a tooltip must have a unique `id` set on the `Button`." if @id.blank? && !Rails.env.production?

        system_arguments[:for_id] = @id
        system_arguments[:type] ||= :description

        Primer::Alpha::Tooltip.new(**system_arguments)
      }

      # @example Schemes
      #   <%= render(Primer::Beta::Button.new) { "Default" } %>
      #   <%= render(Primer::Beta::Button.new(scheme: :primary)) { "Primary" } %>
      #   <%= render(Primer::Beta::Button.new(scheme: :danger)) { "Danger" } %>
      #   <%= render(Primer::Beta::Button.new(scheme: :outline)) { "Outline" } %>
      #   <%= render(Primer::Beta::Button.new(scheme: :invisible)) { "Invisible" } %>
      #   <%= render(Primer::Beta::Button.new(scheme: :link)) { "Link" } %>
      #
      # @example Sizes
      #   <%= render(Primer::Beta::Button.new(size: :small)) { "Small" } %>
      #   <%= render(Primer::Beta::Button.new(size: :medium)) { "Medium" } %>
      #
      # @example Block
      #   <%= render(Primer::Beta::Button.new(block: :true)) { "Block" } %>
      #   <%= render(Primer::Beta::Button.new(block: :true, scheme: :primary)) { "Primary block" } %>
      #
      # @example With leading visual
      #   <%= render(Primer::Beta::Button.new) do |c| %>
      #     <% c.leading_visual_icon(icon: :star) %>
      #     Button
      #   <% end %>
      #
      # @example With trailing visual
      #   <%= render(Primer::Beta::Button.new) do |c| %>
      #     <% c.trailing_visual_counter(count: 15) %>
      #     Button
      #   <% end %>
      #
      # @example With leading and trailing visuals
      #   <%= render(Primer::Beta::Button.new) do |c| %>
      #     <% c.leading_visual_icon(icon: :star) %>
      #     <% c.trailing_visual_counter(count: 15) %>
      #     Button
      #   <% end %>
      #
      # @example With dropdown caret
      #   <%= render(Primer::Beta::Button.new(dropdown: true)) do %>
      #     Button
      #   <% end %>
      #
      # @example With tooltip
      #   @description
      #     Use tooltips sparingly and as a last resort. Consult the <%= link_to_component(Primer::Alpha::Tooltip) %> documentation for more information.
      #   @code
      #     <%= render(Primer::Beta::Button.new(id: "button-with-tooltip")) do |c| %>
      #       <% c.tooltip(text: "Tooltip text") %>
      #       Button
      #     <% end %>
      #
      # @param scheme [Symbol] <%= one_of(Primer::Beta::Button::SCHEME_OPTIONS) %>
      # @param variant [Symbol] DEPRECATED. <%= one_of(Primer::Beta::Button::SIZE_OPTIONS) %>
      # @param size [Symbol] <%= one_of(Primer::Beta::Button::SIZE_OPTIONS) %>
      # @param tag [Symbol] (Primer::Beta::BaseButton::DEFAULT_TAG) <%= one_of(Primer::Beta::BaseButton::TAG_OPTIONS) %>
      # @param type [Symbol] (Primer::Beta::BaseButton::DEFAULT_TYPE) <%= one_of(Primer::Beta::BaseButton::TYPE_OPTIONS) %>
      # @param group_item [Boolean] Whether button is part of a ButtonGroup.
      # @param block [Boolean] Whether button is full-width with `display: block`.
      # @param dropdown [Boolean] Whether or not to render a dropdown caret.
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
      def initialize(
        scheme: DEFAULT_SCHEME,
        variant: nil,
        size: DEFAULT_SIZE,
        group_item: false,
        block: false,
        dropdown: false,
        **system_arguments
      )
        @scheme = scheme
        @dropdown = dropdown

        @system_arguments = system_arguments

        @id = @system_arguments[:id]

        @system_arguments[:classes] = class_names(
          system_arguments[:classes],
          SCHEME_MAPPINGS[fetch_or_fallback(SCHEME_OPTIONS, scheme, DEFAULT_SCHEME)],
          SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, variant || size, DEFAULT_SIZE)],
          "btn" => !link?,
          "btn-block" => block,
          "BtnGroup-item" => group_item
        )
      end

      private

      def link?
        @scheme == LINK_SCHEME
      end

      def trimmed_content
        return if content.blank?

        trimmed_content = content.strip

        return trimmed_content unless content.html_safe?

        # strip unsets `html_safe`, so we have to set it back again to guarantee that HTML blocks won't break
        trimmed_content.html_safe # rubocop:disable Rails/OutputSafety
      end
    end
  end
end