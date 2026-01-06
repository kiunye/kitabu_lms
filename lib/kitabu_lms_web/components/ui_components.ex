defmodule KitabuLmsWeb.UiComponents do
  @moduledoc """
  Kitabu LMS UI Components - Custom design system components
  Following the brand guidelines with teal primary and yellow secondary colors.
  """
  use Phoenix.Component
  import KitabuLmsWeb.CoreComponents

  @doc """
  Primary button component with hover effects and transitions.
  """
  attr(:class, :string, default: "")
  attr(:rest, :global, include: ~w(href navigate patch method download name value disabled))
  slot(:inner_block, required: true)

  def primary_button(assigns) do
    ~H"""
    <.link
      class={[
        "inline-flex items-center justify-center px-6 py-3 text-sm font-semibold text-white transition-all duration-200 rounded-xl bg-primary-500 hover:bg-primary-600 active:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  @doc """
  Secondary button component with yellow accent color.
  """
  attr(:class, :string, default: "")
  attr(:rest, :global, include: ~w(href navigate patch method download name value disabled))
  slot(:inner_block, required: true)

  def secondary_button(assigns) do
    ~H"""
    <.link
      class={[
        "inline-flex items-center justify-center px-6 py-3 text-sm font-semibold text-primary-900 transition-all duration-200 rounded-xl bg-secondary-500 hover:bg-secondary-400 active:bg-secondary-600 focus:outline-none focus:ring-2 focus:ring-secondary-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  @doc """
  Outline button component.
  """
  attr(:class, :string, default: "")
  attr(:rest, :global, include: ~w(href navigate patch method download name value disabled))
  slot(:inner_block, required: true)

  def outline_button(assigns) do
    ~H"""
    <.link
      class={[
        "inline-flex items-center justify-center px-6 py-3 text-sm font-semibold text-primary-600 border-2 border-primary-200 transition-all duration-200 rounded-xl hover:bg-primary-50 hover:border-primary-300 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  @doc """
  Card component with hover shadow effect.
  """
  attr(:class, :string, default: "")
  attr(:rest, :global)
  slot(:inner_block, required: true)
  slot(:header)
  slot(:footer)

  def card(assigns) do
    ~H"""
    <div
      class={[
        "bg-white rounded-2xl border border-neutral-100 shadow-sm transition-all duration-300 hover:shadow-lg",
        @class
      ]}
      {@rest}
    >
      <div :if={@header != []} class="px-6 py-4 border-b border-neutral-100">
        {render_slot(@header)}
      </div>
      <div class="p-6">
        {render_slot(@inner_block)}
      </div>
      <div
        :if={@footer != []}
        class="px-6 py-4 border-t border-neutral-100 bg-neutral-50 rounded-b-2xl"
      >
        {render_slot(@footer)}
      </div>
    </div>
    """
  end

  @doc """
  Course card component with image, title, and price.
  """
  attr(:class, :string, default: "")
  attr(:course, :map, required: true)
  attr(:rest, :global)

  def course_card(assigns) do
    base_class = "group cursor-pointer overflow-hidden"
    extra_class = assigns[:class] || ""
    class = if extra_class != "", do: "#{base_class} #{extra_class}", else: base_class

    assigns = assign(assigns, :card_class, class)

    ~H"""
    <.card
      class={@card_class}
      {@rest}
    >
      <:header>
        <div class="aspect-[16/10] overflow-hidden">
          <img
            src={@course.image_url || "/images/course-placeholder.svg"}
            alt={@course.title}
            class="object-cover w-full h-full transition-transform duration-500 group-hover:scale-105"
          />
        </div>
      </:header>
      <div class="space-y-3">
        <div class="flex items-center gap-2">
          <span class="px-2 py-1 text-xs font-medium text-primary-700 bg-primary-100 rounded-lg">
            {@course.category}
          </span>
          <span
            :if={@course.badge}
            class="px-2 py-1 text-xs font-medium text-secondary-700 bg-secondary-100 rounded-lg"
          >
            {@course.badge}
          </span>
        </div>
        <h3 class="font-display text-lg font-semibold text-neutral-900 group-hover:text-primary-600 transition-colors line-clamp-2">
          {@course.title}
        </h3>
        <p class="text-sm text-neutral-500 line-clamp-2">
          {@course.description}
        </p>
        <div class="flex items-center justify-between pt-2">
          <div class="flex items-center gap-2">
            <span class="text-lg font-bold text-primary-600">
              {format_price(@course.price)}
            </span>
            <span :if={@course.original_price} class="text-sm text-neutral-400 line-through">
              {format_price(@course.original_price)}
            </span>
          </div>
          <div class="flex items-center gap-1 text-sm text-neutral-500">
            <.icon name="hero-star-solid" class="w-4 h-4 text-secondary-500" />
            <span class="font-medium">{@course.rating}</span>
            <span>({@course.students_count})</span>
          </div>
        </div>
      </div>
    </.card>
    """
  end

  @doc """
  Badge component.
  """
  attr(:class, :string, default: "")

  attr(:variant, :string,
    default: "primary",
    values: ["primary", "secondary", "neutral", "success", "warning", "error"]
  )

  slot(:inner_block, required: true)

  def badge(assigns) do
    variants = %{
      "primary" => "bg-primary-100 text-primary-700",
      "secondary" => "bg-secondary-100 text-secondary-700",
      "neutral" => "bg-neutral-100 text-neutral-700",
      "success" => "bg-green-100 text-green-700",
      "warning" => "bg-amber-100 text-amber-700",
      "error" => "bg-red-100 text-red-700"
    }

    assigns = assign_new(assigns, :class, fn -> variants[assigns[:variant] || "primary"] end)

    ~H"""
    <span class={["inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium", @class]}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  Statistic component for hero section.
  """
  attr(:class, :string, default: "")
  attr(:value, :string, required: true)
  attr(:label, :string, required: true)
  attr(:icon, :string, default: nil)

  def stat(assigns) do
    ~H"""
    <div class={["flex items-center gap-4", @class]}>
      <div :if={@icon} class="flex items-center justify-center w-12 h-12 rounded-xl bg-white/10">
        <.icon name={@icon} class="w-6 h-6 text-secondary-400" />
      </div>
      <div>
        <p class="text-3xl font-display font-bold text-white">{@value}</p>
        <p class="text-sm font-medium text-primary-200">{@label}</p>
      </div>
    </div>
    """
  end

  @doc """
  Navigation link component.
  """
  attr(:class, :string, default: "")
  attr(:active, :boolean, default: false)
  attr(:rest, :global, include: ~w(href navigate patch))
  slot(:inner_block, required: true)

  def nav_link(assigns) do
    ~H"""
    <.link
      class={[
        "text-sm font-medium transition-colors duration-200",
        @active && "text-primary-600",
        !@active && "text-neutral-600 hover:text-primary-600",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  @doc """
  Section heading component.
  """
  attr(:class, :string, default: "")
  attr(:subtitle, :string, default: nil)
  attr(:align, :string, default: "left", values: ["left", "center"])
  slot(:inner_block, required: true)

  def section_heading(assigns) do
    ~H"""
    <div class={["max-w-2xl", @align == "center" && "mx-auto text-center", @class]}>
      <h2 class="font-display text-3xl font-bold text-neutral-900 sm:text-4xl">
        {render_slot(@inner_block)}
      </h2>
      <p :if={@subtitle} class="mt-4 text-lg text-neutral-600">
        {@subtitle}
      </p>
    </div>
    """
  end

  defp format_price(nil), do: ""
  defp format_price(price) when is_integer(price), do: "$#{price}"
  defp format_price(price) when is_float(price), do: "$#{Decimal.new(price)}"
end
