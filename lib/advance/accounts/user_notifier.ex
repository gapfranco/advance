defmodule Advance.Accounts.UserNotifier do
  import Bamboo.Email
  alias Advance.Mailer

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
    text_body = """

    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the url below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """

    html_body = """
    Hi #{user.email},<br/></br/>
    You can confirm your account by visiting the url below:<br/></br/>
    <a href="#{url}" target="_blank">#{url}</a><br/></br/>
    If you didn't create an account with us, please ignore this.
    """

    deliver(user.email, "Please confirm your account", text_body, html_body)
  end

  @doc """
  Deliver instructions to reset password account.
  """
  def deliver_reset_password_instructions(user, url) do
    text_body = """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the url below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """

    html_body = """
    Hi #{user.email},<br/></br/>
    You can reset your password by visiting the url below:<br/></br/>
    <a href="#{url}" target="_blank">#{url}</a><br/></br/>
    If you didn't request this change, please ignore this.
    """

    deliver(user.email, "Please confirm your account", text_body, html_body)
  end

  @doc """
  Deliver instructions to update your e-mail.
  """
  def deliver_update_email_instructions(user, url) do
    text_body = """

    ==============================

    Hi #{user.email},

    You can change your e-mail by visiting the url below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """

    html_body = """
    Hi #{user.email},<br/></br/>
    You can change your e-mail by visiting the url below:<br/></br/>
    <a href="#{url}" target="_blank">#{url}</a><br/></br/>
    If you didn't request this change, please ignore this.
    """

    deliver(user.email, "Please confirm your account", text_body, html_body)
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
