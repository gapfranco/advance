defmodule AdvanceWeb.Schema.Resolvers.SessionResolvers do
  alias Advance.Password
  # alias Advance.Accounts
  # alias AdvanceWeb.Schema.Middleware.ChangesetErrors
  # alias Advance.{Email, Mailer}

  def login_user(_, %{email: email, password: password}, _) do
    Password.token_signin(email, password)
  end

  def me(_, _, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def me(_, _, _) do
    {:ok, nil}
  end
end
