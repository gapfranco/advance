defmodule AdvanceWeb.UserRegistrationController do
  use AdvanceWeb, :controller

  alias Advance.Accounts
  alias Advance.Accounts.User
  alias AdvanceWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(
          :info,
          "Conta criada com sucesso. Verifique seu e-mail para instruções de confirmação."
        )
        # |> UserAuth.log_in_user(user)
        |> redirect(to: Routes.user_session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
