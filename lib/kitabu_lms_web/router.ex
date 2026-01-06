defmodule KitabuLmsWeb.Router do
  use KitabuLmsWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {KitabuLmsWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Guardian.Plug.VerifySession)
    plug(Ueberauth)
  end

  pipeline :authenticated do
    plug(Guardian.Plug.EnsureAuthenticated, error_handler: KitabuLmsWeb.Auth.ErrorHandler)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", KitabuLmsWeb do
    pipe_through(:browser)

    live("/", HomeLive, :index)
    live("/sign-in", Auth.LoginLive, :new)
    live("/join", Auth.RegisterLive, :new)
    live("/forgot-password", Auth.ForgotPasswordLive, :new)
    get("/auth/google", AuthController, :request_google)
    get("/auth/google/callback", AuthController, :callback)
    get("/auth/github", AuthController, :request_github)
    get("/auth/github/callback", AuthController, :callback)
    get("/auth/reset-password/:token", AuthController, :reset_password)
    get("/auth/verify-email/:token", AuthController, :verify_email)
  end

  scope "/courses", KitabuLmsWeb do
    pipe_through(:browser)

    live("/", CoursesLive, :index)
    live("/:slug", CourseShowLive, :show)
  end

  scope "/", KitabuLmsWeb do
    pipe_through(:browser)

    live("/about", StaticLive, :about)
    live("/pricing", StaticLive, :pricing)
    live("/contact", StaticLive, :contact)
    live("/terms", StaticLive, :terms)
    live("/privacy", StaticLive, :privacy)
    live("/instructors", StaticLive, :instructors)
    live("/enterprise", StaticLive, :enterprise)
    live("/blog", StaticLive, :blog)
    live("/careers", StaticLive, :careers)
    live("/refunds", StaticLive, :refunds)
  end

  scope "/", KitabuLmsWeb do
    pipe_through([:browser, :authenticated])

    post("/sign-out", AuthController, :sign_out)

    live_session :instructor, on_mount: [KitabuLmsWeb.InitAssigns] do
      live("/instructor", Instructor.DashboardLive, :index)
      live("/instructor/courses", Instructor.CoursesLive, :index)
      live("/instructor/courses/new", Instructor.CourseFormLive, :new)
      live("/instructor/courses/:id", Instructor.CourseEditLive, :edit)
      live("/instructor/courses/:id/edit", Instructor.CourseFormLive, :edit)
      live("/instructor/courses/:id/lessons/:lesson_id", Instructor.CourseEditLive, :edit_lesson)
      live("/instructor/students", Instructor.StudentsLive, :index)
      live("/instructor/analytics", Instructor.AnalyticsLive, :index)
      live("/instructor/settings", Instructor.SettingsLive, :index)
    end
  end

  scope "/api/auth", KitabuLmsWeb do
    pipe_through([:api])

    post("/sign-in", AuthController, :sign_in)
    post("/register", AuthController, :register)
    post("/refresh", AuthController, :refresh)
  end

  if Application.compile_env(:kitabu_lms, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: KitabuLmsWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
