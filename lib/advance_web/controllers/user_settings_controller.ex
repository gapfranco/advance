defmodule AdvanceWeb.UserSettingsController do
  use AdvanceWeb, :controller
  import AdvanceWeb.Gettext

  alias Advance.Accounts
  alias AdvanceWeb.UserAuth

  plug :assign_email_and_password_changesets

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def update(conn, %{"action" => "update_email"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          user.email,
          &Routes.user_settings_url(conn, :confirm_email, &1)
        )

        conn
        |> put_flash(
          :info,
          gettext("A link to confirm your email change has been sent to the new address.")
        )
        |> redirect(to: Routes.page_path(conn, :index))

      # |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", email_changeset: changeset)
    end
  end

  def update_profile(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user

    case Accounts.update_user_profile(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, gettext("Profile updated successfully."))
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        render(conn, "update_profile.html", prfile_changeset: changeset)
    end
  end

  def update_profile(conn, _params) do
    render(conn, "update_profile.html")
  end

  def update_password(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("Password updated successfully."))
        |> put_session(:user_return_to, Routes.page_path(conn, :index))
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, "update_password.html", password_changeset: changeset)
    end
  end

  def update_password(conn, _params) do
    render(conn, "update_password.html")
  end

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:info, gettext("Email changed successfully."))
        |> redirect(to: Routes.page_path(conn, :index))

      # |> redirect(to: Routes.user_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, gettext("Email change link is invalid or it has expired."))
        |> redirect(to: Routes.user_settings_path(conn, :edit))
    end
  end

  def update_avatar(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user

    case Accounts.update_user_avatar(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, gettext("Avatar updated successfully."))
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        render(conn, "update_avatar.html", avatar_changeset: changeset)
    end
  end

  def update_avatar(conn, _params) do
    render(conn, "update_avatar.html")
  end

  def update_locale(conn, %{"locale" => locale}) do
    Gettext.put_locale(AdvanceWeb.Gettext, locale)

    conn
    |> put_session(:locale, locale)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:email_changeset, Accounts.change_user_email(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
    |> assign(:avatar_changeset, Accounts.change_user_avatar(user))
    |> assign(:profile_changeset, Accounts.change_user_profile(user))
    |> assign(:user, user)
  end
end
