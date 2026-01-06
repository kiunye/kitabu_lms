defmodule KitabuLmsWeb.Instructor.SettingsLive do
  @moduledoc """
  Instructor settings LiveView.
  """
  use KitabuLmsWeb, :live_view

  import KitabuLmsWeb.Instructor.Components

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Settings")}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col lg:flex-row gap-6">
      <.instructor_sidebar
        current_user={@current_user}
        active_tab={:settings}
      />

      <div class="flex-1">
        <.instructor_header
          title="Settings"
          subtitle="Manage your instructor profile."
        />

        <div class="mt-6 bg-white rounded-2xl shadow-sm border border-neutral-100 p-12 text-center">
          <.icon name="hero-cog-6-tooth" class="w-12 h-12 text-neutral-300 mx-auto" />
          <p class="mt-4 text-neutral-500">Settings page coming soon</p>
        </div>
      </div>
    </div>
    """
  end
end
