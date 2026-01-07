defmodule KitabuLmsWeb.Instructor.CourseEditLive do
  @moduledoc """
  Course details and curriculum management LiveView for instructors.
  """
  use KitabuLmsWeb, :live_view

  import KitabuLmsWeb.Instructor.Components

  alias KitabuLms.Courses
  alias KitabuLms.Courses.Module, as: CourseModule
  alias KitabuLms.Courses.Lesson

  def mount(%{"id" => id}, _session, socket) do
    course = Courses.get_course!(id)
    modules = list_modules(course.id)

    {:ok,
     assign(socket,
       course: course,
       modules: modules,
       selected_module: nil,
       selected_lesson: nil,
       page_title: course.title
     )}
  end

  def handle_event("select_module", %{"module-id" => module_id}, socket) do
    module = Courses.get_module!(module_id)
    lessons = Lesson.ordered(Lesson.by_module(module.id)) |> KitabuLms.Repo.all()

    {:noreply,
     assign(socket,
       selected_module: module,
       selected_lesson: nil,
       lessons: lessons
     )}
  end

  def handle_event("select_lesson", %{"lesson-id" => lesson_id}, socket) do
    lesson = Courses.get_lesson!(lesson_id)

    {:noreply, assign(socket, selected_lesson: lesson)}
  end

  def handle_event("add_module", _params, socket) do
    module_params = %{
      "title" => "New Module",
      "tenant_id" => socket.assigns.current_tenant.id,
      "course_id" => socket.assigns.course.id,
      "position" => length(socket.assigns.modules) + 1
    }

    case Courses.create_module(module_params) do
      {:ok, module} ->
        modules = list_modules(socket.assigns.course.id)

        {:noreply,
         assign(socket,
           modules: modules,
           selected_module: module,
           selected_lesson: nil,
           lessons: []
         )}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to create module")}
    end
  end

  def handle_event("add_lesson", _params, socket) do
    unless socket.assigns.selected_module do
      {:noreply, put_flash(socket, :error, "Please select a module first")}
    end

    lesson_params = %{
      "title" => "New Lesson",
      "tenant_id" => socket.assigns.current_tenant.id,
      "module_id" => socket.assigns.selected_module.id,
      "position" => length(socket.assigns.lessons || []) + 1,
      "content_type" => "video"
    }

    case Courses.create_lesson(lesson_params) do
      {:ok, lesson} ->
        lessons =
          Lesson.ordered(Lesson.by_module(socket.assigns.selected_module.id))
          |> KitabuLms.Repo.all()

        {:noreply,
         assign(socket,
           lessons: lessons,
           selected_lesson: lesson
         )}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to create lesson")}
    end
  end

  def handle_event("delete_module", %{"id" => module_id}, socket) do
    module = Courses.get_module!(module_id)

    case Courses.delete_module(module) do
      {:ok, _} ->
        modules = list_modules(socket.assigns.course.id)

        {:noreply,
         assign(socket,
           modules: modules,
           selected_module: nil,
           selected_lesson: nil,
           lessons: []
         )}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Failed to delete module")}
    end
  end

  def handle_event("delete_lesson", %{"id" => lesson_id}, socket) do
    lesson = Courses.get_lesson!(lesson_id)

    case Courses.delete_lesson(lesson) do
      {:ok, _} ->
        lessons =
          Lesson.ordered(Lesson.by_module(socket.assigns.selected_module.id))
          |> KitabuLms.Repo.all()

        {:noreply,
         assign(socket,
           lessons: lessons,
           selected_lesson: nil
         )}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Failed to delete lesson")}
    end
  end

  defp list_modules(course_id) do
    CourseModule.ordered(CourseModule.by_course(course_id))
    |> KitabuLms.Repo.all()
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
          title={@course.title}
          subtitle="Manage your course curriculum and content."
        />

        <div class="mt-6 grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div class="lg:col-span-2">
            <.course_curriculum
              course={@course}
              modules={@modules}
              selected_module={@selected_module}
              lessons={@lessons}
            />
          </div>

          <div>
            <.course_details_sidebar course={@course} />
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr(:course, :any, required: true)
  attr(:modules, :list, required: true)
  attr(:selected_module, :any, default: nil)
  attr(:lessons, :list, default: [])

  def course_curriculum(assigns) do
    ~H"""
    <div class="bg-white rounded-2xl shadow-sm border border-neutral-100 overflow-hidden">
      <div class="p-6 border-b border-neutral-100 flex items-center justify-between">
        <h3 class="text-lg font-semibold text-neutral-900">Course Curriculum</h3>
        <.primary_button phx-click="add_module">
          <.icon name="hero-plus" class="w-4 h-4 mr-2" /> Add Module
        </.primary_button>
      </div>

      <div class="divide-y divide-neutral-100">
        <div :for={module <- @modules} class="p-4">
          <div class="flex items-center justify-between">
            <button
              phx-click="select_module"
              phx-value-module-id={module.id}
              class={[
                "flex items-center gap-3 text-left flex-1",
                if(@selected_module && @selected_module.id == module.id,
                  do: "text-primary-600",
                  else: "text-neutral-900"
                )
              ]}
            >
              <.icon
                name={
                  if(@selected_module && @selected_module.id == module.id,
                    do: "hero-chevron-down",
                    else: "hero-chevron-right"
                  )
                }
                class="w-5 h-5"
              />
              <div class="flex-1">
                <p class="font-medium">{module.title}</p>
                <p class="text-sm text-neutral-500">
                  {module.lesson_count || 0} lessons
                </p>
              </div>
            </button>

            <div class="flex items-center gap-2">
              <.link
                navigate={~p"/instructor/courses/#{@course.id}/edit?tab=modules&id=#{module.id}"}
                class="p-2 text-neutral-400 hover:text-primary-600 transition-colors"
              >
                <.icon name="hero-pencil" class="w-4 h-4" />
              </.link>
              <button
                phx-click="delete_module"
                phx-value-id={module.id}
                class="p-2 text-neutral-400 hover:text-red-600 transition-colors"
                data-confirm="Are you sure you want to delete this module?"
              >
                <.icon name="hero-trash" class="w-4 h-4" />
              </button>
            </div>
          </div>

          <div :if={@selected_module && @selected_module.id == module.id} class="mt-4 ml-8 space-y-2">
            <div
              :for={lesson <- @lessons}
              class="flex items-center justify-between p-3 bg-neutral-50 rounded-lg"
            >
              <div class="flex items-center gap-3">
                <.icon name="hero-play-circle" class="w-5 h-5 text-neutral-400" />
                <div>
                  <p class="text-sm font-medium text-neutral-900">{lesson.title}</p>
                  <p class="text-xs text-neutral-500">
                    {lesson.video_duration_seconds || 0}s video
                  </p>
                </div>
              </div>

              <div class="flex items-center gap-2">
                <.link
                  navigate={~p"/instructor/courses/#{@course.id}/lessons/#{lesson.id}"}
                  class="p-1.5 text-neutral-400 hover:text-primary-600 transition-colors"
                >
                  <.icon name="hero-pencil" class="w-4 h-4" />
                </.link>
                <button
                  phx-click="delete_lesson"
                  phx-value-id={lesson.id}
                  class="p-1.5 text-neutral-400 hover:text-red-600 transition-colors"
                  data-confirm="Delete this lesson?"
                >
                  <.icon name="hero-trash" class="w-4 h-4" />
                </button>
              </div>
            </div>

            <button
              phx-click="add_lesson"
              class="w-full py-2 text-sm text-primary-600 hover:text-primary-700 font-medium flex items-center justify-center gap-2 border border-dashed border-primary-200 rounded-lg hover:bg-primary-50 transition-colors"
            >
              <.icon name="hero-plus" class="w-4 h-4" /> Add Lesson
            </button>
          </div>
        </div>

        <div :if={length(@modules) == 0} class="p-12 text-center">
          <.icon name="hero-book-open" class="w-12 h-12 text-neutral-300 mx-auto" />
          <p class="mt-4 text-neutral-500">No modules yet</p>
          <.primary_button class="mt-4" phx-click="add_module">
            Add Your First Module
          </.primary_button>
        </div>
      </div>
    </div>
    """
  end

  attr(:course, :any, required: true)

  def course_details_sidebar(assigns) do
    ~H"""
    <div class="space-y-6">
      <div class="bg-white rounded-2xl shadow-sm border border-neutral-100 p-6">
        <h3 class="text-lg font-semibold text-neutral-900 mb-4">Course Status</h3>

        <div class="space-y-4">
          <div class="flex items-center justify-between">
            <span class="text-sm text-neutral-500">Status</span>
            <.status_badge is_published={@course.is_published} />
          </div>

          <div class="flex items-center justify-between">
            <span class="text-sm text-neutral-500">Price</span>
            <span class="font-medium text-neutral-900">
              {if @course.is_free, do: "Free", else: "$#{@course.price || 0}"}
            </span>
          </div>

          <div class="flex items-center justify-between">
            <span class="text-sm text-neutral-500">Level</span>
            <span class="font-medium text-neutral-900 capitalize">{@course.level}</span>
          </div>
        </div>

        <div class="mt-6 pt-6 border-t border-neutral-100 space-y-3">
          <.link
            navigate={~p"/instructor/courses/#{@course.id}/edit"}
            class="block w-full text-center"
          >
            <.outline_button class="w-full">
              <.icon name="hero-pencil-square" class="w-4 h-4 mr-2" /> Edit Details
            </.outline_button>
          </.link>

          <.link
            navigate={~p"/courses/#{@course.slug}"}
            target="_blank"
            class="block w-full text-center"
          >
            <.secondary_button class="w-full">
              <.icon name="hero-eye" class="w-4 h-4 mr-2" /> Preview
            </.secondary_button>
          </.link>
        </div>
      </div>

      <div class="bg-white rounded-2xl shadow-sm border border-neutral-100 p-6">
        <h3 class="text-lg font-semibold text-neutral-900 mb-4">Quick Actions</h3>

        <div class="space-y-2">
          <.link
            navigate={~p"/instructor/students"}
            class="flex items-center gap-3 p-3 rounded-xl hover:bg-neutral-50 transition-colors"
          >
            <.icon name="hero-users" class="w-5 h-5 text-neutral-400" />
            <span class="text-sm font-medium text-neutral-700">View Students</span>
          </.link>

          <.link
            navigate={~p"/instructor/analytics"}
            class="flex items-center gap-3 p-3 rounded-xl hover:bg-neutral-50 transition-colors"
          >
            <.icon name="hero-chart-bar" class="w-5 h-5 text-neutral-400" />
            <span class="text-sm font-medium text-neutral-700">Analytics</span>
          </.link>
        </div>
      </div>
    </div>
    """
  end
end
