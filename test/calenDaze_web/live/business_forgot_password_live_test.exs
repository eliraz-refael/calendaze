defmodule CalenDazeWeb.BusinessForgotPasswordLiveTest do
  use CalenDazeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import CalenDaze.BusinessAccountsFixtures

  alias CalenDaze.BusinessAccounts
  alias CalenDaze.Repo

  describe "Forgot password page" do
    test "renders email page", %{conn: conn} do
      {:ok, lv, html} = live(conn, ~p"/businesses/reset_password")

      assert html =~ "Forgot your password?"
      assert has_element?(lv, ~s|a[href="#{~p"/businesses/register"}"]|, "Register")
      assert has_element?(lv, ~s|a[href="#{~p"/businesses/log_in"}"]|, "Log in")
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_business(business_fixture())
        |> live(~p"/businesses/reset_password")
        |> follow_redirect(conn, ~p"/")

      assert {:ok, _conn} = result
    end
  end

  describe "Reset link" do
    setup do
      %{business: business_fixture()}
    end

    test "sends a new reset password token", %{conn: conn, business: business} do
      {:ok, lv, _html} = live(conn, ~p"/businesses/reset_password")

      {:ok, conn} =
        lv
        |> form("#reset_password_form", business: %{"email" => business.email})
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "If your email is in our system"

      assert Repo.get_by!(BusinessAccounts.BusinessToken, business_id: business.id).context ==
               "reset_password"
    end

    test "does not send reset password token if email is invalid", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/businesses/reset_password")

      {:ok, conn} =
        lv
        |> form("#reset_password_form", business: %{"email" => "unknown@example.com"})
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "If your email is in our system"
      assert Repo.all(BusinessAccounts.BusinessToken) == []
    end
  end
end
