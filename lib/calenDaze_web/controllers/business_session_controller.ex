defmodule CalenDazeWeb.BusinessSessionController do
  use CalenDazeWeb, :controller

  alias CalenDaze.BusinessAccounts
  alias CalenDazeWeb.BusinessAuth

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully!")
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:business_return_to, ~p"/businesses/settings")
    |> create(params, "Password updated successfully!")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  defp create(conn, %{"business" => business_params}, info) do
    %{"email" => email, "password" => password} = business_params

    if business = BusinessAccounts.get_business_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, info)
      |> BusinessAuth.log_in_business(business, business_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Invalid email or password")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/businesses/log_in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> BusinessAuth.log_out_business()
  end
end
