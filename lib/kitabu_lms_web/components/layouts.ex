defmodule KitabuLmsWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use KitabuLmsWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates("layouts/*")

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr(:flash, :map, required: true, doc: "the map of flash messages")
  attr(:current_scope, :map, default: nil, doc: "the current scope")
  slot(:inner_block, required: true)

  def app(assigns) do
    ~H"""
    <div class="min-h-screen flex flex-col">
      <.navigation />
      <main class="flex-1">
        {render_slot(@inner_block)}
      </main>
      <.footer />
      <.flash_group flash={@flash} />
    </div>
    """
  end

  defp navigation(assigns) do
    ~H"""
    <header class="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-neutral-100">
      <nav class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div class="flex h-16 items-center justify-between">
          <div class="flex items-center gap-8">
            <.link navigate={~p"/"} class="flex items-center gap-2">
              <img src={~p"/images/logo.svg"} alt="Kitabu LMS" class="h-8 w-auto" />
              <span class="font-display text-xl font-bold text-primary-600">Kitabu</span>
            </.link>
            <div class="hidden md:flex items-center gap-6">
              <.nav_link navigate={~p"/courses"}>Courses</.nav_link>
              <.nav_link navigate={~p"/instructors"}>Instructors</.nav_link>
              <.nav_link navigate={~p"/pricing"}>Pricing</.nav_link>
              <.nav_link navigate={~p"/about"}>About</.nav_link>
            </div>
          </div>
          <div class="flex items-center gap-4">
            <.nav_link navigate={~p"/sign-in"} class="hidden sm:inline-flex">Sign In</.nav_link>
            <.primary_button navigate={~p"/join"} class="hidden sm:inline-flex">
              Join Now
            </.primary_button>
            <.link
              navigate={~p"/mobile-menu"}
              class="md:hidden p-2 text-neutral-600 hover:text-primary-600"
            >
              <.icon name="hero-bars-3" class="w-6 h-6" />
            </.link>
          </div>
        </div>
      </nav>
    </header>
    """
  end

  defp footer(assigns) do
    ~H"""
    <footer class="bg-neutral-900 text-neutral-300">
      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-12">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div class="space-y-4">
            <div class="flex items-center gap-2">
              <img src={~p"/images/logo-white.svg"} alt="Kitabu LMS" class="h-8 w-auto" />
              <span class="font-display text-xl font-bold text-white">Kitabu</span>
            </div>
            <p class="text-sm text-neutral-400">
              Empowering learners across Africa with world-class online education.
            </p>
            <div class="flex gap-4">
              <.link class="text-neutral-400 hover:text-white transition-colors">
                <.icon name="hero-facebook" class="w-5 h-5" />
              </.link>
              <.link class="text-neutral-400 hover:text-white transition-colors">
                <.icon name="hero-x-twitter" class="w-5 h-5" />
              </.link>
              <.link class="text-neutral-400 hover:text-white transition-colors">
                <.icon name="hero-instagram" class="w-5 h-5" />
              </.link>
              <.link class="text-neutral-400 hover:text-white transition-colors">
                <.icon name="hero-linkedin" class="w-5 h-5" />
              </.link>
            </div>
          </div>
          <div>
            <h4 class="font-semibold text-white mb-4">Platform</h4>
            <ul class="space-y-2 text-sm">
              <li>
                <.link navigate={~p"/courses"} class="hover:text-white transition-colors">
                  Browse Courses
                </.link>
              </li>
              <li>
                <.link navigate={~p"/instructors"} class="hover:text-white transition-colors">
                  Become an Instructor
                </.link>
              </li>
              <li>
                <.link navigate={~p"/pricing"} class="hover:text-white transition-colors">
                  Pricing
                </.link>
              </li>
              <li>
                <.link navigate={~p"/enterprise"} class="hover:text-white transition-colors">
                  Enterprise
                </.link>
              </li>
            </ul>
          </div>
          <div>
            <h4 class="font-semibold text-white mb-4">Company</h4>
            <ul class="space-y-2 text-sm">
              <li>
                <.link navigate={~p"/about"} class="hover:text-white transition-colors">
                  About Us
                </.link>
              </li>
              <li>
                <.link navigate={~p"/careers"} class="hover:text-white transition-colors">
                  Careers
                </.link>
              </li>
              <li>
                <.link navigate={~p"/blog"} class="hover:text-white transition-colors">Blog</.link>
              </li>
              <li>
                <.link navigate={~p"/contact"} class="hover:text-white transition-colors">
                  Contact
                </.link>
              </li>
            </ul>
          </div>
          <div>
            <h4 class="font-semibold text-white mb-4">Legal</h4>
            <ul class="space-y-2 text-sm">
              <li>
                <.link navigate={~p"/privacy"} class="hover:text-white transition-colors">
                  Privacy Policy
                </.link>
              </li>
              <li>
                <.link navigate={~p"/terms"} class="hover:text-white transition-colors">
                  Terms of Service
                </.link>
              </li>
              <li>
                <.link navigate={~p"/refunds"} class="hover:text-white transition-colors">
                  Refund Policy
                </.link>
              </li>
            </ul>
          </div>
        </div>
        <div class="mt-12 pt-8 border-t border-neutral-800 text-center text-sm text-neutral-500">
          <p>&copy; {Date.utc_today().year} Kitabu LMS. All rights reserved.</p>
        </div>
      </div>
    </footer>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr(:flash, :map, required: true, doc: "the map of flash messages")
  attr(:id, :string, default: "flash-group", doc: "the optional id of flash container")

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end
