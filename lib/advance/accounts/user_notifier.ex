defmodule Advance.Accounts.UserNotifier do
  import Bamboo.Email
  alias Advance.Mailer
  import AdvanceWeb.Gettext

  @from_address "app@m2isrv.com"

  defp deliver(to, subject, text_body, html_body) do
    # email =
    new_email(
      to: to,
      from: @from_address,
      subject: subject,
      text_body: text_body,
      html_body: html_body
    )
    |> Mailer.deliver_now()

    {:ok, %{to: to, body: text_body}}
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    locale = Gettext.get_locale(AdvanceWeb.Gettext)

    text_body =
      cond do
        locale == "en" ->
          """

          ==============================

          Account confirmation

            #{user.name},

          You can confirm your account by visiting the url below:

          #{url}

          If you didn't create an account with us, please ignore this.

          ==============================
          """

        true ->
          """

          ==============================

          Confirmação da conta

            #{user.name},

          Você pode confirmar sua conta visitando o endereço abaixo:

          #{url}

          Se não criou uma conta conosco, por favor ignore esse e-mail.

          ==============================
          """
      end

    html_body =
      cond do
        locale == "en" ->
          """
          <h2>Account confirmation</h2>
          <p>#{user.name},</p><br/></br/>
          Confirm your account by visiting the url below:<br/></br/>
          <a href="#{url}" target="_blank">#{url}</a><br/></br/>
          If you didn't create an account with us, please ignore this.
          """

        true ->
          """
          <h2>Confirmação da conta</h2>
          <p>#{user.name},</p><br/></br/>
          Você pode confirmar sua conta visitando o endereço abaixo:<br/></br/>
          <a href="#{url}" target="_blank">#{url}</a><br/></br/>
          Se não criou uma conta conosco, por favor ignore esse e-mail.
          """
      end

    deliver(user.email, gettext("Please confirm your account"), text_body, html_body)
  end

  @doc """
  Deliver instructions to reset password account.
  """
  def deliver_reset_password_instructions(user, url) do
    locale = Gettext.get_locale(AdvanceWeb.Gettext)

    text_body =
      cond do
        locale == "en" ->
          """

          ==============================

          Reset password

          #{user.name},

          You can reset your password by visiting the url below:

          #{url}

          If you didn't request this change, please ignore this.

          ==============================
          """

        true ->
          """

          ==============================

          Recriar senha

          #{user.name},

          Você pode recriar sua senha acessando o endereço abaixo:

          #{url}

          Se você não solicitou a mudança, por favor ignore isso.

          ==============================
          """
      end

    html_body =
      cond do
        locale == "en" ->
          """
          <h2>Reset password</h2>
          <p>#{user.name},</p><br/></br/>
          You can reset your password by visiting the url below:<br/></br/>
          <a href="#{url}" target="_blank">#{url}</a><br/></br/>
          If you didn't request this change, please ignore this.
          """

        true ->
          """
          <h2>Recriar senha</h2>
          <p>#{user.name},</p><br/></br/>
          Você pode recriar as sua senha acessando o endereço abaixo:<br/></br/>
          <a href="#{url}" target="_blank">#{url}</a><br/></br/>
          Se você não solicitou a mudança, por favor ignore isso.
          """
      end

    deliver(user.email, gettext("Password reset instructions"), text_body, html_body)
  end

  @doc """
  Deliver instructions to update your e-mail.
  """
  def deliver_update_email_instructions(user, url) do
    locale = Gettext.get_locale(AdvanceWeb.Gettext)

    text_body =
      cond do
        locale == "en" ->
          """

          ==============================

          Change email

          Hi #{user.name},

          You can change your e-mail by visiting the url below:

          #{url}

          If you didn't request this change, please ignore this.

          ==============================
          """

        true ->
          """

          ==============================

          Mudança de email

          #{user.name},

          Você pode mudar seu email acessando o endereço abaixo:

          #{url}

          Se você não solicitou a mudança, por favor ignore isso.

          ==============================
          """
      end

    html_body =
      cond do
        locale == "en" ->
          """
          <h2>Change email</h2>
          <p>Hi #{user.name},</p><br/></br/>
          You can change your e-mail by visiting the url below:<br/></br/>
          <a href="#{url}" target="_blank">#{url}</a><br/></br/>
          If you didn't request this change, please ignore this.
          """

        true ->
          """
          <h2>Mudança de email</h2>
          <p>#{user.name},</p><br/></br/>
          Você pode mudar seu email acessando o endereço abaixo:<br/></br/>
          <a href="#{url}" target="_blank">#{url}</a><br/></br/>
          Se você não solicitou a mudança, por favor ignore isso.
          """
      end

    deliver(user.email, gettext("Email change instructions"), text_body, html_body)
  end
end

# defmodule Advance.Accounts.UserNotifier do
#   # For simplicity, this module simply logs messages to the terminal.
#   # You should replace it by a proper email or notification tool, such as:
#   #
#   #   * Swoosh - https://hexdocs.pm/swoosh
#   #   * Bamboo - https://hexdocs.pm/bamboo
#   #
#   defp deliver(to, body) do
#     require Logger
#     Logger.debug(body)
#     {:ok, %{to: to, body: body}}
#   end

#   @doc """
#   Deliver instructions to confirm account.
#   """
#   def deliver_confirmation_instructions(user, url) do
#     deliver(user.email, """

#     ==============================

#     Hi #{user.email},

#     You can confirm your account by visiting the URL below:

#     #{url}

#     If you didn't create an account with us, please ignore this.

#     ==============================
#     """)
#   end

#   @doc """
#   Deliver instructions to reset a user password.
#   """
#   def deliver_reset_password_instructions(user, url) do
#     deliver(user.email, """

#     ==============================

#     Hi #{user.email},

#     You can reset your password by visiting the URL below:

#     #{url}

#     If you didn't request this change, please ignore this.

#     ==============================
#     """)
#   end

#   @doc """
#   Deliver instructions to update a user email.
#   """
#   def deliver_update_email_instructions(user, url) do
#     deliver(user.email, """

#     ==============================

#     Hi #{user.email},

#     You can change your email by visiting the URL below:

#     #{url}

#     If you didn't request this change, please ignore this.

#     ==============================
#     """)
#   end
# end
