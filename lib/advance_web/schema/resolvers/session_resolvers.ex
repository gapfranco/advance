defmodule AdvanceWeb.Schema.Resolvers.SessionResolvers do
  alias Advance.Password
  alias Advance.Accounts
  alias AdvanceWeb.Schema.Middleware.ChangesetErrors
  # alias Advance.{Email, Mailer}

  def login_user(_, %{email: email, password: password}, _) do
    Password.token_signin(email, password)
  end

  def signup_user(_, attrs, _) do
    case Accounts.register_user(attrs) do
      {:ok, user} ->
        {:ok, user}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, ChangesetErrors.transform_errors(changeset)}
    end
  end

  def me(_, _, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def me(_, _, _) do
    {:ok, nil}
  end
end
