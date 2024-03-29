defmodule CalenDaze.BusinessAccounts.BusinessNotifier do
  import Swoosh.Email

  alias CalenDaze.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"CalenDaze", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(business, url) do
    deliver(business.email, "Confirmation instructions", """

    ==============================

    Hi #{business.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a business password.
  """
  def deliver_reset_password_instructions(business, url) do
    deliver(business.email, "Reset password instructions", """

    ==============================

    Hi #{business.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a business email.
  """
  def deliver_update_email_instructions(business, url) do
    deliver(business.email, "Update email instructions", """

    ==============================

    Hi #{business.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
