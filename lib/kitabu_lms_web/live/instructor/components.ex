defmodule KitabuLmsWeb.Instructor.Components do
  @moduledoc """
  Instructor dashboard components.
  """
  use KitabuLmsWeb, :html

  embed_templates("instructor/components/*")

  attr(:current_user, :any, required: true)
  attr(:active_tab, :atom, required: true)

  def instructor_sidebar(assigns) do
    ~H"""
    <div class="w-full lg:w-64 flex-shrink-0">
      <div class="bg-white rounded-2xl shadow-sm border border-neutral-100 overflow-hidden">
        <div class="p-6 border-b border-neutral-100">
          <div class="flex items-center gap-4">
            <img
              src={
                @current_user.avatar_url ||
                  "https://ui-avatars.com/api/?name=#{@current_user.first_name}+#{@current_user.last_name}&background=00af91&color=fff"
              }
              alt={KitabuLms.Accounts.User.full_name(@current_user)}
              class="w-12 h-12 rounded-full object-cover"
            />
            <div>
              <p class="font-semibold text-neutral-900">
                {KitabuLms.Accounts.User.full_name(@current_user)}
              </p>
              <p class="text-sm text-neutral-500">Instructor</p>
            </div>
          </div>
        </div>

        <nav class="p-4">
          <ul class="space-y-1">
            <li>
              <.instructor_nav_link
                navigate={~p"/instructor"}
                active={@active_tab == :dashboard}
              >
                <.icon name="hero-home" class="w-5 h-5 mr-3" /> Dashboard
              </.instructor_nav_link>
            </li>
            <li>
              <.instructor_nav_link
                navigate={~p"/instructor/courses"}
                active={@active_tab in [:courses, :course_edit, :course_new]}
              >
                <.icon name="hero-academic-cap" class="w-5 h-5 mr-3" /> My Courses
              </.instructor_nav_link>
            </li>
            <li>
              <.instructor_nav_link
                navigate={~p"/instructor/students"}
                active={@active_tab == :students}
              >
                <.icon name="hero-users" class="w-5 h-5 mr-3" /> Students
              </.instructor_nav_link>
            </li>
            <li>
              <.instructor_nav_link
                navigate={~p"/instructor/analytics"}
                active={@active_tab == :analytics}
              >
                <.icon name="hero-chart-bar" class="w-5 h-5 mr-3" /> Analytics
              </.instructor_nav_link>
            </li>
            <li>
              <.instructor_nav_link
                navigate={~p"/instructor/settings"}
                active={@active_tab == :settings}
              >
                <.icon name="hero-cog-6-tooth" class="w-5 h-5 mr-3" /> Settings
              </.instructor_nav_link>
            </li>
          </ul>
        </nav>
      </div>
    </div>
    """
  end

  attr(:active, :boolean, default: false)
  attr(:navigate, :any, required: true)
  attr(:class, :string, default: "")
  slot(:inner_block, required: true)

  def instructor_nav_link(assigns) do
    ~H"""
    <.link
      navigate={@navigate}
      class={[
        "flex items-center px-4 py-2.5 rounded-xl text-sm font-medium transition-colors",
        @class,
        if @active do
          "bg-primary-50 text-primary-700"
        else
          "text-neutral-600 hover:bg-neutral-50 hover:text-neutral-900"
        end
      ]}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  attr(:title, :string, required: true)
  attr(:subtitle, :string, default: nil)

  def instructor_header(assigns) do
    ~H"""
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-neutral-900">{@title}</h1>
      <p :if={@subtitle} class="text-neutral-500 mt-1">{@subtitle}</p>
    </div>
    """
  end

  attr(:stats, :map, required: true)

  def instructor_stats(assigns) do
    ~H"""
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      <.stat_card
        label="Total Students"
        value={Integer.to_string(@stats.total_students)}
        icon="hero-users"
        color="primary"
      />
      <.stat_card
        label="Total Revenue"
        value={"$#{:erlang.float_to_binary(@stats.total_revenue, decimals: 2)}"}
        icon="hero-currency-dollar"
        color="secondary"
      />
      <.stat_card
        label="Total Courses"
        value={Integer.to_string(@stats.total_courses)}
        icon="hero-book-open"
        color="green"
      />
      <.stat_card
        label="Published"
        value={Integer.to_string(@stats.published_courses)}
        icon="hero-check-circle"
        color="blue"
      />
    </div>
    """
  end

  attr(:label, :string, required: true)
  attr(:value, :string, required: true)
  attr(:icon, :string, required: true)
  attr(:color, :string, default: "primary")

  def stat_card(assigns) do
    assigns =
      assign(assigns, :color_classes, %{
        "primary" => "bg-primary-50 text-primary-600",
        "secondary" => "bg-secondary-50 text-secondary-600",
        "green" => "bg-green-50 text-green-600",
        "blue" => "bg-blue-50 text-blue-600"
      })

    ~H"""
    <div class="bg-white rounded-2xl shadow-sm border border-neutral-100 p-5">
      <div class="flex items-center justify-between">
        <div>
          <p class="text-sm font-medium text-neutral-500">{@label}</p>
          <p class="text-2xl font-bold text-neutral-900 mt-1">{@value}</p>
        </div>
        <div class={[
          "w-12 h-12 rounded-xl flex items-center justify-center",
          @color_classes[@color]
        ]}>
          <.icon name={@icon} class="w-6 h-6" />
        </div>
      </div>
    </div>
    """
  end

  attr(:courses, :list, required: true)

  def instructor_courses_table(assigns) do
    ~H"""
    <div class="bg-white rounded-2xl shadow-sm border border-neutral-100 overflow-hidden">
      <table class="w-full">
        <thead class="bg-neutral-50 border-b border-neutral-100">
          <tr>
            <th class="text-left text-xs font-semibold text-neutral-500 uppercase tracking-wider px-6 py-4">
              Course
            </th>
            <th class="text-left text-xs font-semibold text-neutral-500 uppercase tracking-wider px-6 py-4">
              Students
            </th>
            <th class="text-left text-xs font-semibold text-neutral-500 uppercase tracking-wider px-6 py-4">
              Revenue
            </th>
            <th class="text-left text-xs font-semibold text-neutral-500 uppercase tracking-wider px-6 py-4">
              Status
            </th>
            <th class="text-right text-xs font-semibold text-neutral-500 uppercase tracking-wider px-6 py-4">
              Actions
            </th>
          </tr>
        </thead>
        <tbody class="divide-y divide-neutral-100">
          <tr :for={course <- @courses} class="hover:bg-neutral-50 transition-colors">
            <td class="px-6 py-4">
              <div class="flex items-center gap-4">
                <img
                  src={course.thumbnail_url || "https://via.placeholder.com/80x45?text=Course"}
                  alt={course.title}
                  class="w-20 h-12 rounded-lg object-cover"
                />
                <div>
                  <p class="font-medium text-neutral-900 line-clamp-1">{course.title}</p>
                  <p class="text-sm text-neutral-500">{course.level}</p>
                </div>
              </div>
            </td>
            <td class="px-6 py-4">
              <span class="font-medium text-neutral-900">{course.enrollment_count || 0}</span>
            </td>
            <td class="px-6 py-4">
              <span class="font-medium text-neutral-900">
                $#{:erlang.float_to_binary(course.revenue || 0, decimals: 2)}
              </span>
            </td>
            <td class="px-6 py-4">
              <.status_badge is_published={course.is_published} />
            </td>
            <td class="px-6 py-4 text-right">
              <div class="flex items-center justify-end gap-2">
                <.link
                  navigate={~p"/instructor/courses/#{course.id}"}
                  class="p-2 text-neutral-400 hover:text-primary-600 transition-colors"
                >
                  <.icon name="hero-pencil-square" class="w-5 h-5" />
                </.link>
                <.link
                  navigate={~p"/courses/#{course.slug}"}
                  class="p-2 text-neutral-400 hover:text-primary-600 transition-colors"
                >
                  <.icon name="hero-eye" class="w-5 h-5" />
                </.link>
              </div>
            </td>
          </tr>
          <tr :if={length(@courses) == 0}>
            <td colspan="5" class="px-6 py-12 text-center">
              <.icon name="hero-book-open" class="w-12 h-12 text-neutral-300 mx-auto" />
              <p class="mt-4 text-neutral-500">No courses yet</p>
              <.primary_button class="mt-4" phx-click={JS.navigate(~p"/instructor/courses/new")}>
                Create Your First Course
              </.primary_button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  attr(:is_published, :boolean, required: true)

  def status_badge(assigns) do
    ~H"""
    <span class={[
      "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium",
      if @is_published do
        "bg-green-100 text-green-800"
      else
        "bg-yellow-100 text-yellow-800"
      end
    ]}>
      {if @is_published, do: "Published", else: "Draft"}
    </span>
    """
  end
end
