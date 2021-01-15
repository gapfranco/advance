defmodule AdvanceWeb.Schema.Resolvers.SessionResolvers do
  alias Advance.Password
  alias Advance.Accounts
  alias AdvanceWeb.Schema.Middleware.ChangesetErrors
  import AdvanceWeb.Gettext

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

  def forgot_password(_, %{email: email}, _) do
    if user = Accounts.get_user_by_email(email) do
      token =
        :crypto.strong_rand_bytes(10)
        |> Base.url_encode64()
        |> binary_part(0, 10)
        |> String.downcase()

      Accounts.deliver_user_reset_password_instructions(user, token)
    end

    {:ok,
     %{
       msg:
         gettext(
           "If your email is in our system, you will receive instructions to reset your password shortly."
         )
     }}
  end

  def reset_password(
        _,
        %{token: token, password: password, password_confirmation: password_confirmation},
        _
      ) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      case Accounts.reset_user_password(user, %{
             "password" => password,
             "password_confirmation" => password_confirmation
           }) do
        {:ok, _user} ->
          {:ok,
           %{
             msg: gettext("Password was changed successfully")
           }}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:error, ChangesetErrors.transform_errors(changeset)}
      end
    else
      {:error, gettext("Reset password link is invalid or it has expired.")}
    end
  end

  def change_password(
        _,
        %{
          old_password: old_password,
          password: password,
          password_confirmation: password_confirmation
        },
        %{context: context}
      ) do
    if user = Accounts.get_user_by_email(context.current_user.email) do
      case Accounts.update_user_password(user, old_password, %{
             password: password,
             password_confirmation: password_confirmation
           }) do
        {:ok, _user} ->
          {:ok,
           %{
             msg: gettext("Password updated successfully")
           }}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:error, ChangesetErrors.transform_errors(changeset)}
      end
    else
      {:error, gettext("an error occurred")}
    end
  end

  def change_profile(
        _,
        %{
          name: name
        },
        %{context: context}
      ) do
    if user = Accounts.get_user_by_email(context.current_user.email) do
      case Accounts.update_user_profile(user, %{
             name: name
           }) do
        {:ok, user} ->
          {:ok, user}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:error, ChangesetErrors.transform_errors(changeset)}
      end
    else
      {:error, gettext("an error occurred")}
    end
  end
end
