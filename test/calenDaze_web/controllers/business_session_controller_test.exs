defmodule CalenDazeWeb.BusinessSessionControllerTest do
  use CalenDazeWeb.ConnCase, async: true

  import CalenDaze.BusinessAccountsFixtures

  setup do
    %{business: business_fixture()}
  end

  describe "POST /businesses/log_in" do
    test "logs the business in", %{conn: conn, business: business} do
      conn =
        post(conn, ~p"/businesses/log_in", %{
          "business" => %{"email" => business.email, "password" => valid_business_password()}
        })

      assert get_session(conn, :business_token)
      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ business.email
      assert response =~ ~p"/businesses/settings"
      assert response =~ ~p"/businesses/log_out"
    end

    test "logs the business in with remember me", %{conn: conn, business: business} do
      conn =
        post(conn, ~p"/businesses/log_in", %{
          "business" => %{
            "email" => business.email,
            "password" => valid_business_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_calen_daze_web_business_remember_me"]
      assert redirected_to(conn) == ~p"/"
    end

    test "logs the business in with return to", %{conn: conn, business: business} do
      conn =
        conn
        |> init_test_session(business_return_to: "/foo/bar")
        |> post(~p"/businesses/log_in", %{
          "business" => %{
            "email" => business.email,
            "password" => valid_business_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Welcome back!"
    end

    test "login following registration", %{conn: conn, business: business} do
      conn =
        conn
        |> post(~p"/businesses/log_in", %{
          "_action" => "registered",
          "business" => %{
            "email" => business.email,
            "password" => valid_business_password()
          }
        })

      assert redirected_to(conn) == ~p"/"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Account created successfully"
    end

    test "login following password update", %{conn: conn, business: business} do
      conn =
        conn
        |> post(~p"/businesses/log_in", %{
          "_action" => "password_updated",
          "business" => %{
            "email" => business.email,
            "password" => valid_business_password()
          }
        })

      assert redirected_to(conn) == ~p"/businesses/settings"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Password updated successfully"
    end

    test "redirects to login page with invalid credentials", %{conn: conn} do
      conn =
        post(conn, ~p"/businesses/log_in", %{
          "business" => %{"email" => "invalid@email.com", "password" => "invalid_password"}
        })

      assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Invalid email or password"
      assert redirected_to(conn) == ~p"/businesses/log_in"
    end
  end

  describe "DELETE /businesses/log_out" do
    test "logs the business out", %{conn: conn, business: business} do
      conn = conn |> log_in_business(business) |> delete(~p"/businesses/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :business_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the business is not logged in", %{conn: conn} do
      conn = delete(conn, ~p"/businesses/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :business_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end
  end
end
