defmodule KitabuLmsWeb.HomeLive do
  @moduledoc """
  Home page LiveView with hero section, stats, and course catalog.
  """
  use KitabuLmsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, featured_courses: featured_courses())}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col">
      <.hero />
      <.stats_section />
      <.featured_courses courses={@featured_courses} />
      <.features_section />
      <.testimonials_section />
      <.cta_section />
    </div>
    """
  end

  defp hero(assigns) do
    ~H"""
    <section class="relative overflow-hidden bg-gradient-to-br from-primary-900 via-primary-800 to-primary-900">
      <div class="absolute inset-0 bg-[url('/images/grid.svg')] opacity-10"></div>
      <div class="absolute top-0 right-0 w-1/2 h-full bg-gradient-to-l from-secondary-500/10 to-transparent">
      </div>
      <div class="relative mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-24 sm:py-32 lg:py-40">
        <div class="lg:grid lg:grid-cols-2 lg:gap-16 items-center">
          <div class="text-center lg:text-left">
            <span class="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/10 text-sm font-medium text-primary-200 mb-6">
              <span class="w-2 h-2 rounded-full bg-secondary-400 animate-pulse"></span>
              New courses added weekly
            </span>
            <h1 class="font-display text-4xl sm:text-5xl lg:text-6xl font-bold text-white leading-tight">
              Unlock Your Potential with <span class="text-secondary-400">World-Class Learning</span>
            </h1>
            <p class="mt-6 text-lg text-primary-100 max-w-xl mx-auto lg:mx-0">
              Join thousands of learners across Africa. Access premium courses, earn certificates, and advance your career with our expert-led online learning platform.
            </p>
            <div class="mt-10 flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
              <.primary_button class="w-full sm:w-auto">
                Explore Courses <.icon name="hero-arrow-right" class="ml-2 w-4 h-4" />
              </.primary_button>
              <.outline_button class="w-full sm:w-auto text-white border-white/30 hover:bg-white/10 hover:border-white/50">
                Watch Demo
              </.outline_button>
            </div>
            <div class="mt-10 flex items-center gap-4 justify-center lg:justify-start text-sm text-primary-200">
              <div class="flex items-center gap-2">
                <.icon name="hero-check-circle" class="w-5 h-5 text-secondary-400" />
                <span>14-day free trial</span>
              </div>
              <div class="flex items-center gap-2">
                <.icon name="hero-check-circle" class="w-5 h-5 text-secondary-400" />
                <span>No credit card required</span>
              </div>
            </div>
          </div>
          <div class="mt-12 lg:mt-0 relative">
            <div class="relative mx-auto w-full max-w-md lg:max-w-full">
              <img
                src="/images/hero-illustration.svg"
                alt="Student learning online"
                class="w-full h-auto drop-shadow-2xl"
              />
              <div
                class="absolute -bottom-8 -left-8 bg-white rounded-2xl shadow-xl p-4 animate-bounce"
                style="animation-duration: 3s;"
              >
                <div class="flex items-center gap-3">
                  <div class="flex -space-x-3">
                    <img
                      class="w-10 h-10 rounded-full border-2 border-white"
                      src="https://i.pravatar.cc/100?img=1"
                      alt=""
                    />
                    <img
                      class="w-10 h-10 rounded-full border-2 border-white"
                      src="https://i.pravatar.cc/100?img=2"
                      alt=""
                    />
                    <img
                      class="w-10 h-10 rounded-full border-2 border-white"
                      src="https://i.pravatar.cc/100?img=3"
                      alt=""
                    />
                  </div>
                  <div>
                    <p class="text-sm font-semibold text-neutral-900">2,500+</p>
                    <p class="text-xs text-neutral-500">Students joined</p>
                  </div>
                </div>
              </div>
              <div class="absolute -top-4 -right-4 bg-white rounded-2xl shadow-xl p-3">
                <div class="flex items-center gap-2">
                  <div class="w-10 h-10 rounded-full bg-green-100 flex items-center justify-center">
                    <.icon name="hero-play-solid" class="w-5 h-5 text-green-600" />
                  </div>
                  <div>
                    <p class="text-sm font-semibold text-neutral-900">Video Course</p>
                    <p class="text-xs text-neutral-500">Available 24/7</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    """
  end

  defp stats_section(assigns) do
    ~H"""
    <section class="bg-primary-900">
      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-12">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <.stat value="270+" label="Online Courses" icon="hero-academic-cap" />
          <.stat value="5,550+" label="Active Students" icon="hero-users" />
          <.stat value="330+" label="Expert Instructors" icon="hero-user-group" />
        </div>
      </div>
    </section>
    """
  end

  defp featured_courses(assigns) do
    ~H"""
    <section class="py-20 bg-neutral-50">
      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <.section_heading subtitle="Start learning today with our hand-picked courses">
          Featured Courses
        </.section_heading>
        <div class="mt-12 grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
          <.course_card :for={course <- @courses} course={course} />
        </div>
        <div class="mt-12 text-center">
          <.primary_button navigate={~p"/courses"}>
            View All Courses <.icon name="hero-arrow-right" class="ml-2 w-4 h-4" />
          </.primary_button>
        </div>
      </div>
    </section>
    """
  end

  defp features_section(assigns) do
    ~H"""
    <section class="py-20 bg-white">
      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <.section_heading subtitle="Why choose Kitabu LMS?" align="center">
          Everything You Need to Succeed
        </.section_heading>
        <div class="mt-16 grid gap-8 md:grid-cols-3">
          <.card class="text-center p-8">
            <div class="w-16 h-16 mx-auto rounded-2xl bg-primary-100 flex items-center justify-center">
              <.icon name="hero-video-camera" class="w-8 h-8 text-primary-600" />
            </div>
            <h3 class="mt-6 text-xl font-semibold text-neutral-900">HD Video Lessons</h3>
            <p class="mt-3 text-neutral-600">
              Crystal clear video content with downloadable resources and transcripts.
            </p>
          </.card>
          <.card class="text-center p-8">
            <div class="w-16 h-16 mx-auto rounded-2xl bg-secondary-100 flex items-center justify-center">
              <.icon name="hero-certificate" class="w-8 h-8 text-secondary-600" />
            </div>
            <h3 class="mt-6 text-xl font-semibold text-neutral-900">Certificates</h3>
            <p class="mt-3 text-neutral-600">
              Earn recognized certificates upon course completion to boost your resume.
            </p>
          </.card>
          <.card class="text-center p-8">
            <div class="w-16 h-16 mx-auto rounded-2xl bg-green-100 flex items-center justify-center">
              <.icon name="hero-chat-bubble-left-right" class="w-8 h-8 text-green-600" />
            </div>
            <h3 class="mt-6 text-xl font-semibold text-neutral-900">Expert Support</h3>
            <p class="mt-3 text-neutral-600">
              Get help from instructors and peers through our active community forums.
            </p>
          </.card>
        </div>
      </div>
    </section>
    """
  end

  defp testimonials_section(assigns) do
    ~H"""
    <section class="py-20 bg-neutral-50">
      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <.section_heading subtitle="What our students say" align="center">
          Trusted by Learners Worldwide
        </.section_heading>
        <div class="mt-12 grid gap-8 md:grid-cols-2 lg:grid-cols-3">
          <.card class="p-6">
            <div class="flex items-center gap-1 mb-4">
              <.icon :for={_ <- 1..5} name="hero-star-solid" class="w-5 h-5 text-secondary-500" />
            </div>
            <p class="text-neutral-600">
              "The courses here transformed my career. I went from a junior developer to a senior engineer in just 6 months!"
            </p>
            <div class="mt-6 flex items-center gap-4">
              <img src="https://i.pravatar.cc/100?img=4" alt="" class="w-12 h-12 rounded-full" />
              <div>
                <p class="font-semibold text-neutral-900">Sarah M.</p>
                <p class="text-sm text-neutral-500">Software Engineer</p>
              </div>
            </div>
          </.card>
          <.card class="p-6">
            <div class="flex items-center gap-1 mb-4">
              <.icon :for={_ <- 1..5} name="hero-star-solid" class="w-5 h-5 text-secondary-500" />
            </div>
            <p class="text-neutral-600">
              "The flexibility to learn at my own pace was exactly what I needed. The certificates helped me land my dream job!"
            </p>
            <div class="mt-6 flex items-center gap-4">
              <img src="https://i.pravatar.cc/100?img=5" alt="" class="w-12 h-12 rounded-full" />
              <div>
                <p class="font-semibold text-neutral-900">James K.</p>
                <p class="text-sm text-neutral-500">Data Analyst</p>
              </div>
            </div>
          </.card>
          <.card class="p-6">
            <div class="flex items-center gap-1 mb-4">
              <.icon :for={_ <- 1..5} name="hero-star-solid" class="w-5 h-5 text-secondary-500" />
            </div>
            <p class="text-neutral-600">
              "Amazing platform with high-quality content. The instructors are true experts in their fields."
            </p>
            <div class="mt-6 flex items-center gap-4">
              <img src="https://i.pravatar.cc/100?img=6" alt="" class="w-12 h-12 rounded-full" />
              <div>
                <p class="font-semibold text-neutral-900">Emily R.</p>
                <p class="text-sm text-neutral-500">Product Manager</p>
              </div>
            </div>
          </.card>
        </div>
      </div>
    </section>
    """
  end

  defp cta_section(assigns) do
    ~H"""
    <section class="py-20 bg-primary-900">
      <div class="mx-auto max-w-4xl px-4 sm:px-6 lg:px-8 text-center">
        <h2 class="font-display text-3xl sm:text-4xl font-bold text-white">
          Ready to Start Learning?
        </h2>
        <p class="mt-4 text-lg text-primary-200">
          Join over 5,550 students already learning on Kitabu LMS. Admission is open now!
        </p>
        <div class="mt-10 flex flex-col sm:flex-row gap-4 justify-center">
          <.secondary_button class="text-primary-900">
            Enroll Now <.icon name="hero-arrow-right" class="ml-2 w-4 h-4" />
          </.secondary_button>
          <.outline_button class="text-white border-white/30 hover:bg-white/10 hover:border-white/50">
            Contact Sales
          </.outline_button>
        </div>
        <p class="mt-8 text-sm text-primary-300">
          No credit card required for 14-day free trial
        </p>
      </div>
    </section>
    """
  end

  defp featured_courses do
    [
      %{
        title: "Complete Web Development Bootcamp",
        description:
          "Learn HTML, CSS, JavaScript, React, Node.js and more with hands-on projects.",
        category: "Development",
        price: 4999,
        original_price: 9999,
        rating: 4.8,
        students_count: 1250,
        image_url: "/images/courses/web-dev.svg",
        badge: "Bestseller"
      },
      %{
        title: "UI/UX Design Masterclass",
        description: "Master Figma, design principles, and create stunning user interfaces.",
        category: "Design",
        price: 3999,
        original_price: 7999,
        rating: 4.9,
        students_count: 890,
        image_url: "/images/courses/uiux.svg",
        badge: "New"
      },
      %{
        title: "Digital Marketing Strategy",
        description: "Learn SEO, social media marketing, and grow your business online.",
        category: "Marketing",
        price: 2999,
        original_price: 5999,
        rating: 4.7,
        students_count: 2100,
        image_url: "/images/courses/marketing.svg",
        badge: nil
      },
      %{
        title: "Data Science with Python",
        description: "Analyze data, build ML models, and extract insights with Python.",
        category: "Data Science",
        price: 5499,
        original_price: 10999,
        rating: 4.9,
        students_count: 780,
        image_url: "/images/courses/data.svg",
        badge: "Popular"
      },
      %{
        title: "Mobile App Development",
        description: "Build iOS and Android apps with Flutter from scratch.",
        category: "Development",
        price: 4499,
        original_price: 8999,
        rating: 4.8,
        students_count: 650,
        image_url: "/images/courses/mobile.svg",
        badge: nil
      },
      %{
        title: "Project Management Professional",
        description: "Master PMP certification exam with real-world project scenarios.",
        category: "Business",
        price: 3499,
        original_price: 6999,
        rating: 4.7,
        students_count: 1100,
        image_url: "/images/courses/pm.svg",
        badge: "Trending"
      }
    ]
  end
end
