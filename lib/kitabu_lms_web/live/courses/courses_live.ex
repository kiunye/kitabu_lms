defmodule KitabuLmsWeb.CoursesLive do
  @moduledoc """
  LiveView for browsing courses.
  """
  use KitabuLmsWeb, :live_view

  alias KitabuLms.Courses

  def mount(_params, _session, socket) do
    courses = Courses.list_courses() |> Enum.filter(& &1.is_published)
    categories = Courses.list_categories()

    {:ok,
     assign(socket,
       courses: courses,
       categories: categories,
       selected_category: nil,
       search_query: ""
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-neutral-50">
      <div class="bg-white border-b border-neutral-200">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
          <h1 class="font-display text-4xl font-bold text-neutral-900 text-center">
            Explore Our Courses
          </h1>
          <p class="mt-4 text-lg text-neutral-600 text-center max-w-2xl mx-auto">
            Learn from expert instructors and advance your career with our comprehensive courses
          </p>
        </div>
      </div>

      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="flex flex-col lg:flex-row gap-8">
          <div class="lg:w-64 flex-shrink-0">
            <div class="bg-white rounded-xl shadow-sm border border-neutral-200 p-6 sticky top-8">
              <h3 class="font-semibold text-neutral-900 mb-4">Categories</h3>
              <div class="space-y-2">
                <button
                  phx-click="filter_by_category"
                  phx-value-category=""
                  class={"w-full text-left px-3 py-2 rounded-lg text-sm transition-colors " <> category_class(@selected_category, nil)}
                >
                  All Categories
                </button>
                <button
                  :for={category <- @categories}
                  phx-click="filter_by_category"
                  phx-value-category={category.id}
                  class={"w-full text-left px-3 py-2 rounded-lg text-sm transition-colors " <> category_class(@selected_category, category.id)}
                >
                  {category.name}
                </button>
              </div>
            </div>
          </div>

          <div class="flex-1">
            <div class="mb-6">
              <form phx-submit="search" class="relative">
                <input
                  type="text"
                  name="search"
                  value={@search_query}
                  placeholder="Search courses..."
                  class="w-full pl-10 pr-4 py-3 rounded-xl border border-neutral-300 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                />
                <svg
                  class="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-neutral-400"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
                  />
                </svg>
              </form>
            </div>

            <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
              <.course_listing :for={course <- @courses} course={course} />
            </div>

            <div :if={length(@courses) == 0} class="text-center py-12">
              <svg
                class="mx-auto h-12 w-12 text-neutral-400"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                />
              </svg>
              <h3 class="mt-2 text-sm font-medium text-neutral-900">No courses found</h3>
              <p class="mt-1 text-sm text-neutral-500">Try adjusting your search or filters.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def course_listing(assigns) do
    ~H"""
    <.link
      navigate={~p"/courses/#{@course.slug}"}
      class="group bg-white rounded-xl shadow-sm border border-neutral-200 overflow-hidden hover:shadow-md transition-shadow"
    >
      <div class="aspect-video bg-neutral-100 relative overflow-hidden">
        <img
          :if={@course.thumbnail_url}
          src={@course.thumbnail_url}
          alt={@course.title}
          class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
        />
        <div :if={!@course.thumbnail_url} class="w-full h-full flex items-center justify-center">
          <svg
            class="h-12 w-12 text-neutral-300"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"
            />
          </svg>
        </div>
        <div class="absolute top-3 left-3">
          <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-white/90 text-neutral-700">
            {@course.level}
          </span>
        </div>
        <div :if={@course.is_free} class="absolute top-3 right-3">
          <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
            Free
          </span>
        </div>
      </div>
      <div class="p-5">
        <div class="flex items-center gap-2 text-sm text-neutral-500 mb-2">
          <span :if={@course.category}>{@course.category.name}</span>
          <span>&bull;</span>
          <span>{@course.duration_hours}h</span>
        </div>
        <h3 class="font-semibold text-neutral-900 group-hover:text-primary-600 transition-colors line-clamp-2">
          {@course.title}
        </h3>
        <p :if={@course.short_description} class="mt-2 text-sm text-neutral-600 line-clamp-2">
          {@course.short_description}
        </p>
        <div class="mt-4 flex items-center justify-between">
          <div class="flex items-center gap-2">
            <div :if={@course.instructor} class="flex items-center gap-2">
              <img
                :if={@course.instructor.avatar_url}
                src={@course.instructor.avatar_url}
                alt={@course.instructor.name}
                class="w-6 h-6 rounded-full"
              />
              <span class="text-sm text-neutral-600">{@course.instructor.name}</span>
            </div>
          </div>
          <div class="flex items-center gap-1">
            <svg class="h-4 w-4 text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
              <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
            </svg>
            <span class="text-sm font-medium text-neutral-900">
              {if(@course.rating, do: Decimal.to_string(@course.rating), else: "N/A")}
            </span>
            <span class="text-sm text-neutral-500">
              ({@course.rating_count || 0})
            </span>
          </div>
        </div>
        <div class="mt-4 pt-4 border-t border-neutral-100">
          <div class="flex items-center justify-between">
            <span class="text-lg font-bold text-neutral-900">
              {format_price(@course)}
            </span>
            <span class="text-sm text-neutral-500">
              {@course.enrollment_count || 0} students
            </span>
          </div>
        </div>
      </div>
    </.link>
    """
  end

  def handle_event("filter_by_category", %{"category" => category_id}, socket) do
    category_id = if category_id == "", do: nil, else: category_id

    courses =
      socket.assigns.courses
      |> filter_by_category(category_id)

    {:noreply,
     assign(socket,
       selected_category: category_id,
       courses: courses
     )}
  end

  def handle_event("search", %{"search" => query}, socket) do
    courses =
      socket.assigns.courses
      |> Enum.filter(fn course ->
        String.contains?(String.downcase(course.title), String.downcase(query)) ||
          String.contains?(
            String.downcase(course.short_description || ""),
            String.downcase(query)
          )
      end)

    {:noreply,
     assign(socket,
       search_query: query,
       courses: courses
     )}
  end

  defp filter_by_category(courses, nil) do
    courses
  end

  defp filter_by_category(courses, category_id) do
    Enum.filter(courses, fn course ->
      course.category_id == category_id
    end)
  end

  defp category_class(selected, actual) do
    if selected == actual do
      "bg-primary-50 text-primary-700 font-medium"
    else
      "text-neutral-600 hover:bg-neutral-50"
    end
  end

  defp format_price(%{is_free: true}), do: "Free"

  defp format_price(course) do
    case course.currency do
      "USD" -> "$#{Decimal.to_string(course.price)}"
      "EUR" -> "#{Decimal.to_string(course.price)}€"
      "GBP" -> "£#{Decimal.to_string(course.price)}"
      _ -> "#{course.currency} #{Decimal.to_string(course.price)}"
    end
  end
end
