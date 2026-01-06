defmodule KitabuLmsWeb.StaticLive do
  @moduledoc """
  LiveView for static pages like about, pricing, contact, etc.
  """
  use KitabuLmsWeb, :live_view

  def mount(_params, _session, socket) do
    page = to_string(socket.assigns.live_action)
    {:ok, assign(socket, page: page)}
  end

  def render(assigns) do
    case assigns.page do
      "about" -> render_about(assigns)
      "pricing" -> render_pricing(assigns)
      "contact" -> render_contact(assigns)
      "terms" -> render_terms(assigns)
      "privacy" -> render_privacy(assigns)
      "instructors" -> render_instructors(assigns)
      "enterprise" -> render_enterprise(assigns)
      "blog" -> render_blog(assigns)
      "careers" -> render_careers(assigns)
      "refunds" -> render_refunds(assigns)
      _ -> render_404(assigns)
    end
  end

  defp render_about(assigns) do
    ~H"""
    <div class="min-h-screen bg-neutral-50">
      <div class="bg-primary-900 text-white py-20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 class="font-display text-4xl lg:text-5xl font-bold mb-6">About Kitabu LMS</h1>
          <p class="text-xl text-primary-100 max-w-3xl mx-auto">
            Empowering learners worldwide with high-quality online education
          </p>
        </div>
      </div>

      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div class="grid lg:grid-cols-2 gap-12 items-center">
          <div>
            <h2 class="font-display text-3xl font-bold text-neutral-900 mb-6">Our Mission</h2>
            <p class="text-lg text-neutral-600 mb-6">
              At Kitabu LMS, we believe that education should be accessible to everyone, everywhere.
              Our platform connects passionate instructors with eager learners, creating a global
              community of knowledge sharing and personal growth.
            </p>
            <p class="text-lg text-neutral-600 mb-6">
              Founded in 2024, we've helped thousands of students advance their careers and pursue
              their passions through our comprehensive course catalog and expert-led instruction.
            </p>
          </div>
          <div class="bg-primary-100 rounded-2xl p-8">
            <div class="grid grid-cols-2 gap-8 text-center">
              <div>
                <div class="text-4xl font-bold text-primary-600">10K+</div>
                <div class="text-neutral-600 mt-2">Students</div>
              </div>
              <div>
                <div class="text-4xl font-bold text-primary-600">500+</div>
                <div class="text-neutral-600 mt-2">Courses</div>
              </div>
              <div>
                <div class="text-4xl font-bold text-primary-600">100+</div>
                <div class="text-neutral-600 mt-2">Instructors</div>
              </div>
              <div>
                <div class="text-4xl font-bold text-primary-600">50+</div>
                <div class="text-neutral-600 mt-2">Countries</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp render_pricing(assigns) do
    ~H"""
    <div class="min-h-screen bg-neutral-50">
      <div class="bg-neutral-900 text-white py-20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 class="font-display text-4xl lg:text-5xl font-bold mb-6">
            Simple, Transparent Pricing
          </h1>
          <p class="text-xl text-neutral-300 max-w-3xl mx-auto">
            Choose the plan that's right for you. No hidden fees, cancel anytime.
          </p>
        </div>
      </div>

      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div class="grid md:grid-cols-3 gap-8">
          <div class="bg-white rounded-2xl shadow-sm border border-neutral-200 p-8">
            <h3 class="font-display text-xl font-bold text-neutral-900">Free</h3>
            <div class="mt-4 mb-6">
              <span class="text-4xl font-bold text-neutral-900">$0</span>
              <span class="text-neutral-500">/month</span>
            </div>
            <ul class="space-y-4 mb-8">
              <li class="flex items-center gap-3">
                <svg class="h-5 w-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span class="text-neutral-600">Access to free courses</span>
              </li>
              <li class="flex items-center gap-3">
                <svg class="h-5 w-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span class="text-neutral-600">Community forums</span>
              </li>
              <li class="flex items-center gap-3">
                <svg class="h-5 w-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span class="text-neutral-600">Basic progress tracking</span>
              </li>
            </ul>
            <.primary_button class="w-full">Get Started</.primary_button>
          </div>

          <div class="bg-white rounded-2xl shadow-lg border-2 border-primary-500 p-8 relative">
            <div class="absolute -top-4 left-1/2 -translate-x-1/2 bg-primary-500 text-white px-4 py-1 rounded-full text-sm font-medium">
              Most Popular
            </div>
            <h3 class="font-display text-xl font-bold text-neutral-900">Pro</h3>
            <div class="mt-4 mb-6">
              <span class="text-4xl font-bold text-neutral-900">$29</span>
              <span class="text-neutral-500">/month</span>
            </div>
            <ul class="space-y-4 mb-8">
              <li class="flex items-center gap-3">
                <svg class="h-5 w-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span class="text-neutral-600">All free features</span>
              </li>
              <li class="flex items-center gap-3">
                <svg class="h-5 w-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span class="text-neutral-600">Unlimited course access</span>
              </li>
              <li class="flex items-center gap-3">
                <svg class="h-5 w-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span class="text-neutral-600">Certificates of completion</span>
              </li>
              <li class="flex items-center gap-3">
                <svg class="h-5 w-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span class="text-neutral-600">Offline viewing</span>
              </li>
            </ul>
            <.primary_button class="w-full">Start Free Trial</.primary_button>
          </div>

          <div class="bg-white rounded-2xl shadow-sm border border-neutral-200 p-8">
            <h3 class="font-display text-xl font-bold text-neutral-900">Enterprise</h3>
            <div class="mt-4 mb-6">
              <span class="text-4xl font-bold text-neutral-900">Custom</span>
            </div>
            <ul class="space-y-4 mb-8">
              <li class="flex items-center gap-3">
                <svg class="h-5 w-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span class="text-neutral-600">All Pro features</span>
              </li>
              <li class="flex items-center gap-3">
                <svg class="h-5 w-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span class="text-neutral-600">Custom branding</span>
              </li>
              <li class="flex items-center gap-3">
                <svg class="h-5 w-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span class="text-neutral-600">Admin dashboard</span>
              </li>
              <li class="flex items-center gap-3">
                <svg class="h-5 w-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span class="text-neutral-600">Priority support</span>
              </li>
            </ul>
            <.secondary_button class="w-full">Contact Sales</.secondary_button>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp render_contact(assigns) do
    ~H"""
    <div class="min-h-screen bg-neutral-50">
      <div class="bg-neutral-900 text-white py-20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 class="font-display text-4xl lg:text-5xl font-bold mb-6">Get in Touch</h1>
          <p class="text-xl text-neutral-300 max-w-3xl mx-auto">
            Have questions? We'd love to hear from you.
          </p>
        </div>
      </div>

      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div class="grid lg:grid-cols-2 gap-12">
          <div>
            <h2 class="font-display text-2xl font-bold text-neutral-900 mb-6">Send us a message</h2>
            <form class="space-y-6">
              <div>
                <label class="block text-sm font-medium text-neutral-700 mb-2">Name</label>
                <input
                  type="text"
                  class="w-full px-4 py-3 rounded-lg border border-neutral-300 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                  placeholder="Your name"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-neutral-700 mb-2">Email</label>
                <input
                  type="email"
                  class="w-full px-4 py-3 rounded-lg border border-neutral-300 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                  placeholder="you@example.com"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-neutral-700 mb-2">Message</label>
                <textarea
                  rows="5"
                  class="w-full px-4 py-3 rounded-lg border border-neutral-300 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                  placeholder="How can we help?"
                ></textarea>
              </div>
              <.primary_button class="w-full py-3">Send Message</.primary_button>
            </form>
          </div>
          <div>
            <h2 class="font-display text-2xl font-bold text-neutral-900 mb-6">
              Other ways to reach us
            </h2>
            <div class="space-y-6">
              <div class="flex items-start gap-4">
                <div class="w-12 h-12 bg-primary-100 rounded-lg flex items-center justify-center flex-shrink-0">
                  <svg
                    class="h-6 w-6 text-primary-600"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                    />
                  </svg>
                </div>
                <div>
                  <h3 class="font-medium text-neutral-900">Email</h3>
                  <p class="text-neutral-600">support@kitabu.com</p>
                </div>
              </div>
              <div class="flex items-start gap-4">
                <div class="w-12 h-12 bg-primary-100 rounded-lg flex items-center justify-center flex-shrink-0">
                  <svg
                    class="h-6 w-6 text-primary-600"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"
                    />
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"
                    />
                  </svg>
                </div>
                <div>
                  <h3 class="font-medium text-neutral-900">Location</h3>
                  <p class="text-neutral-600">Nairobi, Kenya</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp render_terms(assigns) do
    ~H"""
    <div class="min-h-screen bg-neutral-50 py-16">
      <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="font-display text-3xl font-bold text-neutral-900 mb-8">Terms of Service</h1>
        <div class="prose prose-neutral max-w-none space-y-6 text-neutral-600">
          <p>Last updated: January 2024</p>
          <p>By accessing or using Kitabu LMS, you agree to be bound by these Terms of Service.</p>
          <h2 class="text-xl font-semibold text-neutral-900">1. Acceptance of Terms</h2>
          <p>
            By accessing and using this platform, you accept and agree to be bound by the terms and provision of this agreement.
          </p>
          <h2 class="text-xl font-semibold text-neutral-900">2. Use of Service</h2>
          <p>
            You agree to use our services only for lawful purposes and in accordance with these Terms.
          </p>
          <h2 class="text-xl font-semibold text-neutral-900">3. User Accounts</h2>
          <p>You are responsible for maintaining the confidentiality of your account credentials.</p>
        </div>
      </div>
    </div>
    """
  end

  defp render_privacy(assigns) do
    ~H"""
    <div class="min-h-screen bg-neutral-50 py-16">
      <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="font-display text-3xl font-bold text-neutral-900 mb-8">Privacy Policy</h1>
        <div class="prose prose-neutral max-w-none space-y-6 text-neutral-600">
          <p>Last updated: January 2024</p>
          <p>
            Your privacy is important to us. This policy explains how we collect, use, and protect your information.
          </p>
          <h2 class="text-xl font-semibold text-neutral-900">1. Information We Collect</h2>
          <p>
            We collect information you provide directly to us, such as when you create an account or enroll in a course.
          </p>
          <h2 class="text-xl font-semibold text-neutral-900">2. How We Use Information</h2>
          <p>We use the information we collect to provide, maintain, and improve our services.</p>
          <h2 class="text-xl font-semibold text-neutral-900">3. Data Protection</h2>
          <p>We implement appropriate security measures to protect your personal information.</p>
        </div>
      </div>
    </div>
    """
  end

  defp render_instructors(assigns) do
    ~H"""
    <div class="min-h-screen bg-neutral-50">
      <div class="bg-neutral-900 text-white py-20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 class="font-display text-4xl lg:text-5xl font-bold mb-6">Our Instructors</h1>
          <p class="text-xl text-neutral-300 max-w-3xl mx-auto">
            Learn from industry experts and passionate educators
          </p>
        </div>
      </div>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div class="text-center">
          <p class="text-neutral-600">Meet our amazing team of instructors coming soon.</p>
          <.link navigate={~p"/join"} class="inline-block mt-4">
            <.primary_button>Become an Instructor</.primary_button>
          </.link>
        </div>
      </div>
    </div>
    """
  end

  defp render_enterprise(assigns) do
    ~H"""
    <div class="min-h-screen bg-neutral-50">
      <div class="bg-primary-900 text-white py-20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 class="font-display text-4xl lg:text-5xl font-bold mb-6">Enterprise Solutions</h1>
          <p class="text-xl text-primary-100 max-w-3xl mx-auto">
            Train your team with customized learning experiences
          </p>
        </div>
      </div>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div class="text-center">
          <p class="text-neutral-600 mb-8">Contact our sales team for custom enterprise solutions.</p>
          <.primary_button>Contact Sales</.primary_button>
        </div>
      </div>
    </div>
    """
  end

  defp render_blog(assigns) do
    ~H"""
    <div class="min-h-screen bg-neutral-50 py-16">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="font-display text-3xl font-bold text-neutral-900 mb-8">Blog</h1>
        <div class="text-center py-12">
          <p class="text-neutral-600">Blog posts coming soon.</p>
        </div>
      </div>
    </div>
    """
  end

  defp render_careers(assigns) do
    ~H"""
    <div class="min-h-screen bg-neutral-50 py-16">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="font-display text-3xl font-bold text-neutral-900 mb-8">Careers</h1>
        <div class="text-center py-12">
          <p class="text-neutral-600">Join our team! Job openings coming soon.</p>
        </div>
      </div>
    </div>
    """
  end

  defp render_refunds(assigns) do
    ~H"""
    <div class="min-h-screen bg-neutral-50 py-16">
      <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="font-display text-3xl font-bold text-neutral-900 mb-8">Refund Policy</h1>
        <div class="prose prose-neutral max-w-none space-y-6 text-neutral-600">
          <p>Last updated: January 2024</p>
          <p>We want you to be completely satisfied with your purchase.</p>
          <h2 class="text-xl font-semibold text-neutral-900">30-Day Money Back Guarantee</h2>
          <p>
            If you're not satisfied with your purchase within 30 days, we'll provide a full refund.
          </p>
          <h2 class="text-xl font-semibold text-neutral-900">How to Request a Refund</h2>
          <p>Contact our support team at support@kitabu.com with your order details.</p>
        </div>
      </div>
    </div>
    """
  end

  defp render_404(assigns) do
    ~H"""
    <div class="min-h-screen bg-neutral-50 flex items-center justify-center">
      <div class="text-center">
        <h1 class="font-display text-4xl font-bold text-neutral-900 mb-4">Page Not Found</h1>
        <p class="text-neutral-600 mb-8">The page you're looking for doesn't exist.</p>
        <.link navigate={~p"/"}>
          <.primary_button>Go Home</.primary_button>
        </.link>
      </div>
    </div>
    """
  end
end
