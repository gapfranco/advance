defmodule Advance.Password do
  import Bcrypt

  alias Advance.Guardian
  alias Advance.Accounts.User
  alias Advance.Repo

  def hash(password) do
    hash_pwd_salt(password)
  end

  def verify_with_hash(password, hash), do: verify_pass(password, hash)

  def dummy_verify, do: no_user_verify()

  def token_signin(email, password) do
    with {:ok, user} <- password_auth(email, password),
         {:ok, jwt_token, _} <- Guardian.encode_and_sign(user) do
      {:ok, %{token: jwt_token, user: user}}
      # else
      #   _ -> {:error, :login_error1}
    end
  end

  defp password_auth(uid, password) when is_binary(uid) and is_binary(password) do
    with {:ok, user} <- get_by_uid(uid),
         do: verify_password(password, user)
  end

  defp get_by_uid(uid) when is_binary(uid) do
    case Repo.get_by(User, email: uid) do
      nil ->
        dummy_verify()
        {:error, :invalid_email_password}

      user ->
        if user.is_blocked do
          {:error, :user_blocked}
        else
          {:ok, user}
        end
    end
  end

  def verify_password(password, %User{} = user) when is_binary(password) do
    if verify_with_hash(password, user.hashed_password) do
      {:ok, user}
    else
      {:error, :invalid_email_password}
    end
  end
end
