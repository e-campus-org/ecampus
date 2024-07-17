defmodule BackendWeb.AuthController do
  use BackendWeb, :controller

  use PhoenixSwagger

  alias Backend.Auth.Guardian

  action_fallback(BackendWeb.FallbackController)

  def swagger_definitions do
    %{
      EmailAndPassport:
        swagger_schema do
          title("Email and Password")
          description("An user account of the application")

          properties do
            email(:string, "User email", required: true)
            password(:string, "User password", required: true)
          end

          example(%{
            email: "test@example.com",
            password: "qwerty123!"
          })
        end,
      TokenResult:
        swagger_schema do
          title("Token result")
          description("Object containing jwt token data")

          properties do
            access_token(:string, "User access token")
          end

          example(%{
            access_token:
              "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJFLUNhbXB1cyIsImV4cCI6MTcyMzYzNDA1OSwiaWF0IjoxNzIxMjE0ODU5LCJpc3MiOiJFLUNhbXB1cyIsImp0aSI6ImJlZTM0ODFiLTFmMTUtNDdiYi05YmIwLTQzYTk0MDhiYjgzYyIsIm5iZiI6MTcyMTIxNDg1OCwic3ViIjoiMTIiLCJ0eXAiOiJhY2Nlc3MifQ.o5kKkF_CJXsl0zrVoew38KCqqUMpPrn5qzJHcIuQQFYNZfCu0K2SerpHQTPlUqQOaHFzaWrzFFM497BtMSmb3Q"
          })
        end
    }
  end

  swagger_path :sign_in do
    post("/auth/signin")
    summary("Singin in the application")
    description("Singin in the application using email and password")
    produces("application/json")
    tag("Auth")

    parameters do
      account(:body, Schema.ref(:EmailAndPassport), "Data to sign in", required: true)
    end

    response(200, "Success", Schema.ref(:TokenResult))
    response(400, "Bad request (Unknown error)")
    response(401, "Unauthorized (wrong email or password)")
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, _account, token} ->
        conn
        |> put_status(:ok)
        |> render(:token, token: token)

      {:error, :unauthorized} ->
        {:error, :unauthorized}
    end
  end
end
