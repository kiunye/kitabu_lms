defmodule KitabuLmsWeb.Instructor.DashboardLive do
  @moduledoc """
  Instructor dashboard LiveView for managing courses and viewing analytics.
  """
  use KitabuLmsWeb, :live_view

  import Ecto.Query
  import KitabuLmsWeb.Instructor.Components

  alias KitabuLms.Courses.Course

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    courses =
      Course.by_instructor(Course, current_user.instructor_id)
      |> Course.by_tenant(socket.assigns.current_tenant.id)
      |> KitabuLms.Repo.all()
      |> Enum.map(&load_course_stats/1)

    stats = calculate_instructor_stats(courses)

    {:ok,
     assign(socket,
       courses: courses,
       stats: stats,
       page_title: "Instructor Dashboard"
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col lg:flex-row gap-6">
      <.instructor_sidebar
        current_user={@current_user}
        active_tab={:dashboard}
      />

      <div class="flex-1">
        <.instructor_header
          title="Dashboard"
          subtitle="Welcome back! Here's what's happening with your courses."
        />

        <.instructor_stats stats={@stats} />

        <div class="mt-8">
          <div class="flex items-center justify-between mb-4">
            <h2 class="text-lg font-semibold text-neutral-900">Your Courses</h2>
            <.primary_button phx-click={JS.navigate(~p"/instructor/courses/new")}>
              <.icon name="hero-plus" class="w-4 h-4 mr-2" /> New Course
            </.primary_button>
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

  defp calculate_instructor_stats(courses) do
    total_students = Enum.reduce(courses, 0, fn c, acc -> acc + (c.enrollment_count || 0) end)
    total_revenue = Enum.reduce(courses, 0, fn c, acc -> acc + (c.revenue || 0) end)
    total_courses = length(courses)
    published_courses = Enum.count(courses, fn c -> c.is_published end)

    %{
      total_students: total_students,
      total_revenue: total_revenue,
      total_courses: total_courses,
      published_courses: published_courses
    }
  end
end
