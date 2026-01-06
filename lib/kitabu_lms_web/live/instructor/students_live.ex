defmodule KitabuLmsWeb.Instructor.StudentsLive do
  @moduledoc """
  Instructor students management LiveView.
  """
  use KitabuLmsWeb, :live_view

  import KitabuLmsWeb.Instructor.Components

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Students")}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col lg:flex-row gap-6">
      <.instructor_sidebar
        current_user={@current_user}
        active_tab={:students}
      />

      <div class="flex-1">
        <.instructor_header
          title="Students"
          subtitle="View and manage your students."
        />

        <div class="mt-6 bg-white rounded-2xl shadow-sm border border-neutral-100 p-12 text-center">
          <.icon name="hero-users" class="w-12 h-12 text-neutral-300 mx-auto" />
          <p class="mt-4 text-neutral-500">Student management coming soon</p>
        </div>
      </div>
    </div>
    """
  end
end
