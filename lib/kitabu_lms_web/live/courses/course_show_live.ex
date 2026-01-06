defmodule KitabuLmsWeb.CourseShowLive do
  @moduledoc """
  LiveView for showing a single course.
  """
  use KitabuLmsWeb, :live_view

  alias KitabuLms.Courses

  def mount(%{"slug" => slug}, _session, socket) do
    course =
      Courses.list_courses()
      |> Enum.find(fn c -> c.slug == slug end)

    if course do
      course = Courses.get_course!(course.id)
      categories = Courses.list_categories()

      {:ok,
       assign(socket,
         course: course,
         categories: categories,
         active_tab: "overview"
       )}
    else
      {:ok, redirect(socket, to: "/courses")}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-neutral-50">
      <div class="bg-neutral-900 text-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <div class="grid lg:grid-cols-3 gap-8">
            <div class="lg:col-span-2">
              <nav class="flex gap-4 mb-6 text-sm">
                <.link
                  navigate={~p"/courses"}
                  class="text-neutral-400 hover:text-white transition-colors"
                >
                  Courses
                </.link>
                <span class="text-neutral-600">/</span>
                <span class="text-neutral-300">{@course.title}</span>
              </nav>

              <h1 class="font-display text-3xl lg:text-4xl font-bold mb-4">{@course.title}</h1>

              <p class="text-lg text-neutral-300 mb-6">{@course.short_description}</p>

              <div class="flex flex-wrap items-center gap-4 text-sm">
                <div class="flex items-center gap-1">
                  <svg class="h-5 w-5 text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                  </svg>
                  <span class="font-medium">{@course.rating || "N/A"}</span>
                  <span class="text-neutral-400">({@course.rating_count || 0} reviews)</span>
                </div>

                <span class="text-neutral-500">|</span>

                <span>{@course.enrollment_count || 0} students</span>

                <span class="text-neutral-500">|</span>

                <span class="capitalize">{@course.level}</span>

                <span class="text-neutral-500">|</span>

                <span>{@course.duration_hours}h</span>
              </div>

              <div class="flex items-center gap-3 mt-6">
                <img
                  :if={@course.instructor && @course.instructor.avatar_url}
                  src={@course.instructor.avatar_url}
                  alt={@course.instructor.name}
                  class="w-10 h-10 rounded-full"
                />
                <div>
                  <p class="text-sm text-neutral-400">Created by</p>
                  <p class="font-medium">
                    {(@course.instructor && @course.instructor.name) || "Unknown"}
                  </p>
                </div>
              </div>
            </div>

            <div class="lg:col-span-1">
              <div class="bg-white rounded-xl shadow-lg overflow-hidden text-neutral-900 sticky top-8">
                <div class="aspect-video bg-neutral-100 relative">
                  <img
                    :if={@course.thumbnail_url}
                    src={@course.thumbnail_url}
                    alt={@course.title}
                    class="w-full h-full object-cover"
                  />
                  <div class="absolute inset-0 flex items-center justify-center">
                    <button class="w-16 h-16 rounded-full bg-white/90 flex items-center justify-center hover:bg-white transition-colors">
                      <svg
                        class="h-8 w-8 text-primary-600 ml-1"
                        fill="currentColor"
                        viewBox="0 0 20 20"
                      >
                        <path d="M6.3 2.841A1.5 1.5 0 004 4.11V15.89a1.5 1.5 0 002.3 1.269l9.344-5.89a1.5 1.5 0 000-2.538L6.3 2.84z" />
                      </svg>
                    </button>
                  </div>
                </div>

                <div class="p-6">
                  <div class="text-3xl font-bold mb-4">
                    {format_price(@course)}
                  </div>

                  <.primary_button class="w-full py-3 mb-3">
                    Enroll Now
                  </.primary_button>

                  <.secondary_button class="w-full py-3">
                    Add to Cart
                  </.secondary_button>

                  <div class="mt-6 space-y-4 text-sm">
                    <div class="flex items-center gap-3">
                      <svg
                        class="h-5 w-5 text-neutral-400"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                        />
                      </svg>
                      <span>{@course.duration_hours} hours of content</span>
                    </div>
                    <div class="flex items-center gap-3">
                      <svg
                        class="h-5 w-5 text-neutral-400"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                        />
                      </svg>
                      <span>Certificate of completion</span>
                    </div>
                    <div class="flex items-center gap-3">
                      <svg
                        class="h-5 w-5 text-neutral-400"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M3 15a4 4 0 004 4h9a5 5 0 10-.1-9.999 5.002 5.002 0 10-9.78 2.096A4.001 4.001 0 003 15z"
                        />
                      </svg>
                      <span>Lifetime access</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="lg:grid lg:grid-cols-3 lg:gap-8">
          <div class="lg:col-span-2">
            <div class="border-b border-neutral-200 mb-6">
              <nav class="flex gap-8">
                <button
                  phx-click="set_tab"
                  phx-value-tab="overview"
                  class={"pb-4 text-sm font-medium border-b-2 transition-colors " <> tab_class(@active_tab, "overview")}
                >
                  Overview
                </button>
                <button
                  phx-click="set_tab"
                  phx-value-tab="curriculum"
                  class={"pb-4 text-sm font-medium border-b-2 transition-colors " <> tab_class(@active_tab, "curriculum")}
                >
                  Curriculum
                </button>
                <button
                  phx-click="set_tab"
                  phx-value-tab="instructor"
                  class={"pb-4 text-sm font-medium border-b-2 transition-colors " <> tab_class(@active_tab, "instructor")}
                >
                  Instructor
                </button>
                <button
                  phx-click="set_tab"
                  phx-value-tab="reviews"
                  class={"pb-4 text-sm font-medium border-b-2 transition-colors " <> tab_class(@active_tab, "reviews")}
                >
                  Reviews
                </button>
              </nav>
            </div>

            <div :if={@active_tab == "overview"}>
              <h2 class="text-2xl font-bold text-neutral-900 mb-4">About this course</h2>
              <div class="prose prose-neutral max-w-none">
                <p class="text-neutral-600">{@course.description}</p>
              </div>

              <div class="mt-8">
                <h3 class="text-lg font-semibold text-neutral-900 mb-4">What you'll learn</h3>
                <div class="grid sm:grid-cols-2 gap-3">
                  <div class="flex gap-3">
                    <svg
                      class="h-5 w-5 text-green-500 flex-shrink-0 mt-0.5"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fill-rule="evenodd"
                        d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                        clip-rule="evenodd"
                      />
                    </svg>
                    <span class="text-neutral-600">Understand core concepts</span>
                  </div>
                  <div class="flex gap-3">
                    <svg
                      class="h-5 w-5 text-green-500 flex-shrink-0 mt-0.5"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fill-rule="evenodd"
                        d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                        clip-rule="evenodd"
                      />
                    </svg>
                    <span class="text-neutral-600">Build real-world projects</span>
                  </div>
                  <div class="flex gap-3">
                    <svg
                      class="h-5 w-5 text-green-500 flex-shrink-0 mt-0.5"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fill-rule="evenodd"
                        d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                        clip-rule="evenodd"
                      />
                    </svg>
                    <span class="text-neutral-600">Best practices and patterns</span>
                  </div>
                  <div class="flex gap-3">
                    <svg
                      class="h-5 w-5 text-green-500 flex-shrink-0 mt-0.5"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fill-rule="evenodd"
                        d="M16.707 5.293a1 1 0 414l-8010 1. 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                        clip-rule="evenodd"
                      />
                    </svg>
                    <span class="text-neutral-600">Career advancement skills</span>
                  </div>
                </div>
              </div>
            </div>

            <div :if={@active_tab == "curriculum"}>
              <h2 class="text-2xl font-bold text-neutral-900 mb-4">Course Curriculum</h2>
              <div class="space-y-4">
                <div
                  :for={{module, index} <- Enum.with_index(@course.modules || [])}
                  class="border border-neutral-200 rounded-lg overflow-hidden"
                >
                  <button
                    phx-click="toggle_module"
                    phx-value-module-id={module.id}
                    class="w-full flex items-center justify-between p-4 bg-neutral-50 hover:bg-neutral-100 transition-colors"
                  >
                    <div class="flex items-center gap-3">
                      <span class="w-8 h-8 rounded-full bg-primary-100 text-primary-700 flex items-center justify-center text-sm font-medium">
                        {index + 1}
                      </span>
                      <span class="font-medium text-neutral-900">{module.title}</span>
                    </div>
                    <div class="flex items-center gap-4 text-sm text-neutral-500">
                      <span>{length(module.lessons || [])} lessons</span>
                      <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M19 9l-7 7-7-7"
                        />
                      </svg>
                    </div>
                  </button>
                </div>
              </div>
            </div>

            <div :if={@active_tab == "instructor"}>
              <h2 class="text-2xl font-bold text-neutral-900 mb-4">About the Instructor</h2>
              <div :if={@course.instructor} class="flex gap-6">
                <img
                  :if={@course.instructor.avatar_url}
                  src={@course.instructor.avatar_url}
                  alt={@course.instructor.name}
                  class="w-24 h-24 rounded-full object-cover"
                />
                <div>
                  <h3 class="text-xl font-semibold text-neutral-900">{@course.instructor.name}</h3>
                  <p class="text-neutral-600 mt-1">{@course.instructor.title || "Instructor"}</p>
                  <p class="text-neutral-500 text-sm mt-4">
                    {@course.instructor.bio || "No bio available."}
                  </p>
                </div>
              </div>
              <div :if={!@course.instructor} class="text-center py-8 bg-neutral-50 rounded-lg">
                <p class="text-neutral-500">Instructor information not available.</p>
              </div>
            </div>

            <div :if={@active_tab == "reviews"}>
              <h2 class="text-2xl font-bold text-neutral-900 mb-4">Student Reviews</h2>
              <div class="text-center py-8 bg-neutral-50 rounded-lg">
                <p class="text-neutral-500">No reviews yet. Be the first to review this course!</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("set_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, active_tab: tab)}
  end

  def handle_event("toggle_module", %{"module-id" => _module_id}, socket) do
    {:noreply, socket}
  end

  defp tab_class(active_tab, tab) do
    if active_tab == tab do
      "border-primary-600 text-primary-600"
    else
      "border-transparent text-neutral-500 hover:text-neutral-700"
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
