defmodule AdvanceWeb.UserSessionController do
  use AdvanceWeb, :controller
  import AdvanceWeb.Gettext

  alias Advance.Accounts
  alias AdvanceWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    with {:ok, user} <- Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      {:error, :bad_username_or_password} ->
        render(conn, "new.html", error_message: gettext("Invalid email or password"))

      {:error, :user_blocked} ->
        render(conn, "new.html",
          error_message: gettext("Your account is blocked. Please contact system administrator.")
        )

      {:error, :not_confirmed} ->
        user = Accounts.get_user_by_email(email)

        Accounts.deliver_user_confirmation_instructions(
          user,
          &Routes.user_confirmation_url(conn, :confirm, &1)
        )

        render(conn, "new.html",
          error_message:
            gettext(
              "Please confirme your e-mail before connecting. A confirmation email was sent to you."
            )
        )
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, gettext("Logged out successfully."))
    |> UserAuth.log_out_user()
  end
end
