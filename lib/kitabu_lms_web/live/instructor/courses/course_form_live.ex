defmodule KitabuLmsWeb.Instructor.CourseFormLive do
  @moduledoc """
  Course creation/editing LiveView for instructors.
  """
  use KitabuLmsWeb, :live_view

  import KitabuLmsWeb.Instructor.Components

  alias KitabuLms.Courses
  alias KitabuLms.Courses.Course
  alias KitabuLms.Courses.Category

  def mount(%{"id" => id}, _session, socket) do
    course = Courses.get_course!(id)
    categories = list_categories(socket.assigns.current_tenant.id)

    changeset = Courses.change_course(course)

    {:ok,
     assign(socket,
       course: course,
       changeset: changeset,
       categories: categories,
       page_title: if(course.id, do: "Edit Course", else: "New Course")
     )}
  end

  def mount(_params, _session, socket) do
    categories = list_categories(socket.assigns.current_tenant.id)

    changeset =
      %Course{}
      |> Course.changeset(%{})
      |> Map.put(:action, :insert)

    {:ok,
     assign(socket,
       course: nil,
       changeset: changeset,
       categories: categories,
       page_title: "New Course"
     )}
  end

  def handle_event("validate", %{"course" => course_params}, socket) do
    changeset =
      socket.assigns.course
      |> Course.changeset(course_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"course" => course_params}, socket) do
    save_course(socket, socket.assigns.action, course_params)
  end

  defp save_course(socket, :edit, course_params) do
    case Courses.update_course(socket.assigns.course, course_params) do
      {:ok, _course} ->
        {:noreply,
         socket
         |> put_flash(:success, "Course updated successfully")
         |> push_navigate(to: ~p"/instructor/courses")}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_course(socket, :new, course_params) do
    course_params =
      course_params
      |> Map.put("tenant_id", socket.assigns.current_tenant.id)
      |> Map.put("instructor_id", socket.assigns.current_user.instructor_id)

    case Courses.create_course(course_params) do
      {:ok, course} ->
        {:noreply,
         socket
         |> put_flash(:success, "Course created successfully")
         |> push_navigate(to: ~p"/instructor/courses/#{course.id}")}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp list_categories(tenant_id) do
    Category.by_tenant(tenant_id)
    |> Category.active()
    |> KitabuLms.Repo.all()
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col lg:flex-row gap-6">
      <.instructor_sidebar
        current_user={@current_user}
        active_tab={:courses}
      />

      <div class="flex-1 max-w-4xl">
        <.instructor_header
          title={@page_title}
          subtitle="Fill in the details to create your course."
        />

        <.course_form changeset={@changeset} categories={@categories} />
      </div>
    </div>
    """
  end

  attr(:changeset, :any, required: true)
  attr(:categories, :list, required: true)

  def course_form(assigns) do
    ~H"""
    <.form
      for={@changeset}
      id="course-form"
      phx-change="validate"
      phx-submit="save"
      class="space-y-8"
    >
      <div class="bg-white rounded-2xl shadow-sm border border-neutral-100 p-6">
        <h3 class="text-lg font-semibold text-neutral-900 mb-6">Basic Information</h3>

        <div class="grid grid-cols-1 gap-6">
          <div>
            <.input
              field={@changeset[:title]}
              label="Course Title"
              placeholder="e.g., Complete Web Development Bootcamp"
            />
          </div>

          <div>
            <.input
              field={@changeset[:short_description]}
              label="Short Description"
              placeholder="A brief summary of your course (max 200 characters)"
              maxlength="200"
            />
          </div>

          <div>
            <.input
              field={@changeset[:description]}
              label="Full Description"
              type="textarea"
              rows="5"
              placeholder="Detailed description of what students will learn..."
            />
          </div>
        </div>
      </div>

      <div class="bg-white rounded-2xl shadow-sm border border-neutral-100 p-6">
        <h3 class="text-lg font-semibold text-neutral-900 mb-6">Categorization</h3>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <.input
              field={@changeset[:category_id]}
              label="Category"
              type="select"
              options={[{"Select a category", ""} | Enum.map(@categories, fn c -> {c.name, c.id} end)]}
            />
          </div>

          <div>
            <.input
              field={@changeset[:level]}
              label="Level"
              type="select"
              options={["beginner", "intermediate", "advanced", "all"]}
            />
          </div>

          <div>
            <.input
              field={@changeset[:language]}
              label="Language"
              type="select"
              options={["English", "Swahili", "French"]}
            />
          </div>

          <div>
            <.input
              field={@changeset[:duration_hours]}
              label="Duration (hours)"
              type="number"
              min="0"
            />
          </div>
        </div>
      </div>

      <div class="bg-white rounded-2xl shadow-sm border border-neutral-100 p-6">
        <h3 class="text-lg font-semibold text-neutral-900 mb-6">Pricing</h3>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div>
            <.input
              field={@changeset[:price]}
              label="Price (USD)"
              type="number"
              min="0"
              step="0.01"
            />
          </div>

          <div>
            <.input
              field={@changeset[:original_price]}
              label="Original Price (USD)"
              type="number"
              min="0"
              step="0.01"
            />
          </div>

          <div class="flex items-center pt-6">
            <.input
              field={@changeset[:is_free]}
              label="Free Course"
              type="checkbox"
              class="flex items-center gap-2"
            />
          </div>
        </div>
      </div>

      <div class="bg-white rounded-2xl shadow-sm border border-neutral-100 p-6">
        <h3 class="text-lg font-semibold text-neutral-900 mb-6">Media</h3>

        <div class="grid grid-cols-1 gap-6">
          <div>
            <.input
              field={@changeset[:thumbnail_url]}
              label="Thumbnail URL"
              placeholder="https://example.com/image.jpg"
            />
          </div>

          <div>
            <.input
              field={@changeset[:preview_video_url]}
              label="Preview Video URL"
              placeholder="https://youtube.com/watch?v=..."
            />
          </div>
        </div>
      </div>

      <div class="bg-white rounded-2xl shadow-sm border border-neutral-100 p-6">
        <h3 class="text-lg font-semibold text-neutral-900 mb-6">Publishing</h3>

        <div class="flex items-center gap-6">
          <.input
            field={@changeset[:is_published]}
            label="Publish immediately"
            type="checkbox"
          />
        </div>
      </div>

      <div class="flex items-center justify-end gap-4">
        <.link navigate={~p"/instructor/courses"} class="text-neutral-600 hover:text-neutral-900">
          Cancel
        </.link>
        <.primary_button type="submit">
          {if @changeset.data.id, do: "Update Course", else: "Create Course"}
        </.primary_button>
      </div>
    </.form>
    """
  end
end
