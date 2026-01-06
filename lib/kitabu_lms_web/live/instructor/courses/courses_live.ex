defmodule KitabuLmsWeb.Instructor.CoursesLive do
  @moduledoc """
  Instructor courses list LiveView.
  """
  use KitabuLmsWeb, :live_view

  import Ecto.Query
  import KitabuLmsWeb.Instructor.Components

  alias KitabuLms.Courses
  alias KitabuLms.Courses.Course

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    courses =
      Course.by_instructor(Course, current_user.instructor_id)
      |> Course.by_tenant(socket.assigns.current_tenant.id)
      |> KitabuLms.Repo.all()
      |> Enum.map(&load_course_stats/1)

    {:ok, assign(socket, courses: courses, page_title: "My Courses")}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col lg:flex-row gap-6">
      <.instructor_sidebar
        current_user={@current_user}
        active_tab={:courses}
      />

      <div class="flex-1">
        <.instructor_header
          title="My Courses"
          subtitle="Manage and update your course catalog."
        />

        <div class="mt-6">
          <div class="flex items-center justify-between mb-6">
            <.primary_button phx-click={JS.navigate(~p"/instructor/courses/new")}>
              <.icon name="hero-plus" class="w-4 h-4 mr-2" /> New Course
            </.primary_button>

            <div class="flex items-center gap-3">
              <.input
                type="search"
                name="search"
                placeholder="Search courses..."
                class="w-64"
              />
              <.input type="select" name="status" options={["All", "Published", "Draft"]} />
            </div>
          </div>

          <.instructor_courses_table courses={@courses} />
        </div>
      </div>
    </div>
    """
  end

  defp load_course_stats(course) do
    enrollment_count =
      KitabuLms.Courses.Enrollment.by_course(course.id)
      |> KitabuLms.Repo.aggregate(:count, :id)

    revenue_query =
      from(oi in KitabuLms.Orders.OrderItem,
        join: o in KitabuLms.Orders.Order,
        on: o.id == oi.order_id,
        where: oi.course_id == ^course.id,
        where: o.status in ["completed", "paid"],
        select: sum(oi.price_at_purchase)
      )

    revenue =
      KitabuLms.Repo.one(revenue_query)
      |> then(&(&1 || Decimal.new(0)))
      |> Decimal.to_float()

    Map.put(course, :enrollment_count, enrollment_count)
    |> Map.put(:revenue, revenue)
  end
end
