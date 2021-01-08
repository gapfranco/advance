defmodule AdvanceWeb.UserSessionController do
  use AdvanceWeb, :controller

  alias Advance.Accounts
  alias AdvanceWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  # def create(conn, %{"user" => user_params}) do
  #   %{"email" => email, "password" => password} = user_params

  #   if user = Accounts.get_user_by_email_and_password(email, password) do
  #     UserAuth.log_in_user(conn, user, user_params)
  #   else
  #     render(conn, "new.html", error_message: "Invalid email or password")
  #   end
  # end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    with {:ok, user} <- Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      {:error, :bad_username_or_password} ->
        render(conn, "new.html", error_message: "E-mail ou senha inválidos.")

      {:error, :user_blocked} ->
        render(conn, "new.html",
          error_message: "Sua conta foi bloqueada, por favor contacte o administrador."
        )

      {:error, :not_confirmed} ->
        user = Accounts.get_user_by_email(email)

        Accounts.deliver_user_confirmation_instructions(
          user,
          &Routes.user_confirmation_url(conn, :confirm, &1)
        )

        render(conn, "new.html",
          error_message:
            "Por favor confirma seu e-mail antes de conectar. Um e-mail de confirmação foi enviado para você."
        )
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Desconectado com sucesso.")
    |> UserAuth.log_out_user()
  end
end
