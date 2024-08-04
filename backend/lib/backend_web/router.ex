defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {BackendWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(Backend.Auth.Pipeline)
  end

  scope "/api", BackendWeb do
    pipe_through(:api)
    post("/accounts/init", AccountController, :init)
    post("/auth/signin", AuthController, :sign_in)
  end

  scope "/api", BackendWeb do
    pipe_through([:api, :auth])

    get("/accounts", AccountController, :index)
    get("/accounts/:id", AccountController, :show)
    post("/accounts", AccountController, :create)
    put("/accounts/:id", AccountController, :update)
    delete("/accounts/:id", AccountController, :delete)

    get("/specialities", SpecialityController, :index)
    get("/specialities/:id", SpecialityController, :show)
    post("/specialities", SpecialityController, :create)
    put("/specialities/:id", SpecialityController, :update)
    delete("/specialities/:id", SpecialityController, :delete)

    get("/groups", GroupController, :index)
    get("/groups/:id", GroupController, :show)
    post("/groups", GroupController, :create)
    put("/groups/:id", GroupController, :update)
    delete("/groups/:id", GroupController, :delete)

    get("/subjects", SubjectController, :index)
    get("/subjects/:id", SubjectController, :show)
    post("/subjects", SubjectController, :create)
    put("/subjects/:id", SubjectController, :update)
    delete("/subjects/:id", SubjectController, :delete)

    get("/lessons", LessonController, :index)
    get("/lessons/:id", LessonController, :show)
    post("/lessons", LessonController, :create)
    put("/lessons/:id", LessonController, :update)
    delete("/lessons/:id", LessonController, :delete)

    get("/lesson_topics", LessonTopicController, :index)
    get("/lesson_topics/:id", LessonTopicController, :show)
    post("/lesson_topics", LessonTopicController, :create)
    put("/lesson_topics/:id", LessonTopicController, :update)
    delete("/lesson_topics/:id", LessonTopicController, :delete)
  end

  scope "/api/swagger" do
    forward("/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :backend, swagger_file: "swagger.json")
  end

  # Other scopes may use custom stacks.
  # scope "/api", BackendWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:backend, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: BackendWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  def swagger_info do
    %{
      basePath: "/api",
      info: %{
        version: "1.0",
        title: "E-Campus"
      },
      tags: [
        %{name: "Auth", description: "Operations with authentication"},
        %{name: "Accounts", description: "Operations with Accounts"},
        %{name: "Groups", description: "Operations with Groups"},
        %{name: "Specialities", description: "Operations with Specialities"},
        %{name: "Subjects", description: "Operations with Subjects"},
        %{name: "Lessons", description: "Operations with Lessons"},
        %{name: "LessonTopics", description: "Operations with LessonTopics"}
      ],
      securityDefinitions: %{
        bearer: %{
          type: "apiKey",
          name: "Authorization",
          in: "header",
          description: "Enter the token with the 'Bearer: ' prefix, e.g. 'Bearer abcde12345'"
        }
      }
    }
  end
end
