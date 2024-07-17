defmodule Backend.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :backend,
    module: Backend.Auth.Guardian,
    error_handler: Backend.Auth.GuardianErrorHandler

  plug(Guardian.Plug.VerifySession)
  plug(Guardian.Plug.VerifyHeader)
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
