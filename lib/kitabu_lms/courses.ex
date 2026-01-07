defmodule KitabuLms.Courses do
  @moduledoc """
  The Courses context.
  """

  alias KitabuLms.Repo

  alias KitabuLms.Courses.Course

  @doc """
  Returns the list of courses.
  """
  def list_courses do
    Repo.all(Course)
  end

  @doc """
  Gets a single course.
  """
  def get_course!(id) do
    Repo.get!(Course, id)
    |> Repo.preload([:instructor, :category, :modules])
  end

  @doc """
  Creates a course.
  """
  def create_course(attrs \\ %{}) do
    %Course{}
    |> Course.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a course.
  """
  def update_course(%Course{} = course, attrs) do
    course
    |> Course.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a course.
  """
  def delete_course(%Course{} = course) do
    Repo.delete(course)
  end

  @doc """
  Returns a changeset for tracking course changes.
  """
  def change_course(%Course{} = course, attrs \\ %{}) do
    Course.changeset(course, attrs)
  end

  alias KitabuLms.Courses.Module

  @doc """
  Returns the list of modules.
  """
  def list_modules do
    Repo.all(Module)
  end

  @doc """
  Gets a single module.
  """
  def get_module!(id) do
    Repo.get!(Module, id)
    |> Repo.preload([:course, :lessons])
  end

  @doc """
  Creates a module.
  """
  def create_module(attrs \\ %{}) do
    %Module{}
    |> Module.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a module.
  """
  def update_module(%Module{} = module, attrs) do
    module
    |> Module.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a module.
  """
  def delete_module(%Module{} = module) do
    Repo.delete(module)
  end

  @doc """
  Returns a changeset for tracking module changes.
  """
  def change_module(%Module{} = module, attrs \\ %{}) do
    Module.changeset(module, attrs)
  end

  alias KitabuLms.Courses.Lesson

  @doc """
  Returns the list of lessons.
  """
  def list_lessons do
    Repo.all(Lesson)
  end

  @doc """
  Gets a single lesson.
  """
  def get_lesson!(id) do
    Repo.get!(Lesson, id)
    |> Repo.preload([:module])
  end

  @doc """
  Creates a lesson.
  """
  def create_lesson(attrs \\ %{}) do
    %Lesson{}
    |> Lesson.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lesson.
  """
  def update_lesson(%Lesson{} = lesson, attrs) do
    lesson
    |> Lesson.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a lesson.
  """
  def delete_lesson(%Lesson{} = lesson) do
    Repo.delete(lesson)
  end

  @doc """
  Returns a changeset for tracking lesson changes.
  """
  def change_lesson(%Lesson{} = lesson, attrs \\ %{}) do
    Lesson.changeset(lesson, attrs)
  end

  alias KitabuLms.Courses.Enrollment

  @doc """
  Returns the list of enrollments.
  """
  def list_enrollments do
    Repo.all(Enrollment)
  end

  @doc """
  Gets a single enrollment.
  """
  def get_enrollment!(id) do
    Repo.get!(Enrollment, id)
    |> Repo.preload([:user, :course])
  end

  @doc """
  Creates an enrollment.
  """
  def create_enrollment(attrs \\ %{}) do
    %Enrollment{}
    |> Enrollment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an enrollment.
  """
  def update_enrollment(%Enrollment{} = enrollment, attrs) do
    enrollment
    |> Enrollment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an enrollment.
  """
  def delete_enrollment(%Enrollment{} = enrollment) do
    Repo.delete(enrollment)
  end

  @doc """
  Returns a changeset for tracking enrollment changes.
  """
  def change_enrollment(%Enrollment{} = enrollment, attrs \\ %{}) do
    Enrollment.changeset(enrollment, attrs)
  end

  alias KitabuLms.Courses.Category

  @doc """
  Returns the list of categories.
  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.
  """
  def get_category!(id) do
    Repo.get!(Category, id)
  end

  @doc """
  Creates a category.
  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.
  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.
  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns a changeset for tracking category changes.
  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end
end
