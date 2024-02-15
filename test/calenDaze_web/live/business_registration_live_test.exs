defmodule CalenDazeWeb.BusinessRegistrationLiveTest do
  use CalenDazeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import CalenDaze.BusinessAccountsFixtures

  describe "Registration page" do
    test "renders registration page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/businesses/register")

      assert html =~ "Register"
      assert html =~ "Log in"
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_business(business_fixture())
        |> live(~p"/businesses/register")
        |> follow_redirect(conn, "/")

      assert {:ok, _conn} = result
    end

    test "renders errors for invalid data", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/businesses/register")

      result =
        lv
        |> element("#registration_form")
        |> render_change(business: %{"email" => "with spaces", "password" => "too short"})

      assert result =~ "Register"
      assert result =~ "must have the @ sign and no spaces"
      assert result =~ "should be at least 12 character"
    end
  end

  describe "register business" do
    test "creates account and logs the business in", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/businesses/register")

      email = unique_business_email()
      form = form(lv, "#registration_form", business: valid_business_attributes(email: email))
      render_submit(form)
      conn = follow_trigger_action(form, conn)

      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ "Settings"
      assert response =~ "Log out"
    end

    test "renders errors for duplicated email", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/businesses/register")

      business = business_fixture(%{email: "test@email.com"})

      result =
        lv
        |> form("#registration_form",
          business: %{"email" => business.email, "password" => "valid_password"}
        )
        |> render_submit()

      assert result =~ "has already been taken"
    end
  end

  describe "registration navigation" do
    test "redirects to login page when the Log in button is clicked", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/businesses/register")

      {:ok, _login_live, login_html} =
        lv
        |> element(~s|main a:fl-contains("Sign in")|)
        |> render_click()
        |> follow_redirect(conn, ~p"/businesses/log_in")

      assert login_html =~ "Log in"
    end
  end
end
