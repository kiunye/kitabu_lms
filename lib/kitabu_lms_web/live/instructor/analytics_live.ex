defmodule KitabuLmsWeb.Instructor.AnalyticsLive do
  @moduledoc """
  Instructor analytics LiveView.
  """
  use KitabuLmsWeb, :live_view

  import KitabuLmsWeb.Instructor.Components

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Analytics")}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col lg:flex-row gap-6">
      <.instructor_sidebar
        current_user={@current_user}
        active_tab={:analytics}
      />

      <div class="flex-1">
        <.instructor_header
          title="Analytics"
          subtitle="Track your course performance."
        />

        <div class="mt-6 bg-white rounded-2xl shadow-sm border border-neutral-100 p-12 text-center">
          <.icon name="hero-chart-bar" class="w-12 h-12 text-neutral-300 mx-auto" />
          <p class="mt-4 text-neutral-500">Analytics dashboard coming soon</p>
        </div>
      </div>
    </div>
    """
  end
end
