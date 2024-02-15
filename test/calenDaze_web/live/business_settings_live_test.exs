defmodule CalenDazeWeb.BusinessSettingsLiveTest do
  use CalenDazeWeb.ConnCase, async: true

  alias CalenDaze.BusinessAccounts
  import Phoenix.LiveViewTest
  import CalenDaze.BusinessAccountsFixtures

  describe "Settings page" do
    test "renders settings page", %{conn: conn} do
      {:ok, _lv, html} =
        conn
        |> log_in_business(business_fixture())
        |> live(~p"/businesses/settings")

      assert html =~ "Change Email"
      assert html =~ "Change Password"
    end

    test "redirects if business is not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/businesses/settings")

      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/businesses/log_in"
      assert %{"error" => "You must log in to access this page."} = flash
    end
  end

  describe "update email form" do
    setup %{conn: conn} do
      password = valid_business_password()
      business = business_fixture(%{password: password})
      %{conn: log_in_business(conn, business), business: business, password: password}
    end

    test "updates the business email", %{conn: conn, password: password, business: business} do
      new_email = unique_business_email()

      {:ok, lv, _html} = live(conn, ~p"/businesses/settings")

      result =
        lv
        |> form("#email_form", %{
          "current_password" => password,
          "business" => %{"email" => new_email}
        })
        |> render_submit()

      assert result =~ "A link to confirm your email"
      assert BusinessAccounts.get_business_by_email(business.email)
    end

    test "renders errors with invalid data (phx-change)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/businesses/settings")

      result =
        lv
        |> element("#email_form")
        |> render_change(%{
          "action" => "update_email",
          "current_password" => "invalid",
          "business" => %{"email" => "with spaces"}
        })

      assert result =~ "Change Email"
      assert result =~ "must have the @ sign and no spaces"
    end

    test "renders errors with invalid data (phx-submit)", %{conn: conn, business: business} do
      {:ok, lv, _html} = live(conn, ~p"/businesses/settings")

      result =
        lv
        |> form("#email_form", %{
          "current_password" => "invalid",
          "business" => %{"email" => business.email}
        })
        |> render_submit()

      assert result =~ "Change Email"
      assert result =~ "did not change"
      assert result =~ "is not valid"
    end
  end

  describe "update password form" do
    setup %{conn: conn} do
      password = valid_business_password()
      business = business_fixture(%{password: password})
      %{conn: log_in_business(conn, business), business: business, password: password}
    end

    test "updates the business password", %{conn: conn, business: business, password: password} do
      new_password = valid_business_password()

      {:ok, lv, _html} = live(conn, ~p"/businesses/settings")

      form =
        form(lv, "#password_form", %{
          "current_password" => password,
          "business" => %{
            "email" => business.email,
            "password" => new_password,
            "password_confirmation" => new_password
          }
        })

      render_submit(form)

      new_password_conn = follow_trigger_action(form, conn)

      assert redirected_to(new_password_conn) == ~p"/businesses/settings"

      assert get_session(new_password_conn, :business_token) != get_session(conn, :business_token)

      assert Phoenix.Flash.get(new_password_conn.assigns.flash, :info) =~
               "Password updated successfully"

      assert BusinessAccounts.get_business_by_email_and_password(business.email, new_password)
    end

    test "renders errors with invalid data (phx-change)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/businesses/settings")

      result =
        lv
        |> element("#password_form")
        |> render_change(%{
          "current_password" => "invalid",
          "business" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      assert result =~ "Change Password"
      assert result =~ "should be at least 12 character(s)"
      assert result =~ "does not match password"
    end

    test "renders errors with invalid data (phx-submit)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/businesses/settings")

      result =
        lv
        |> form("#password_form", %{
          "current_password" => "invalid",
          "business" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })
        |> render_submit()

      assert result =~ "Change Password"
      assert result =~ "should be at least 12 character(s)"
      assert result =~ "does not match password"
      assert result =~ "is not valid"
    end
  end

  describe "confirm email" do
    setup %{conn: conn} do
      business = business_fixture()
      email = unique_business_email()

      token =
        extract_business_token(fn url ->
          BusinessAccounts.deliver_business_update_email_instructions(%{business | email: email}, business.email, url)
        end)

      %{conn: log_in_business(conn, business), token: token, email: email, business: business}
    end

    test "updates the business email once", %{conn: conn, business: business, token: token, email: email} do
      {:error, redirect} = live(conn, ~p"/businesses/settings/confirm_email/#{token}")

      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/businesses/settings"
      assert %{"info" => message} = flash
      assert message == "Email changed successfully."
      refute BusinessAccounts.get_business_by_email(business.email)
      assert BusinessAccounts.get_business_by_email(email)

      # use confirm token again
      {:error, redirect} = live(conn, ~p"/businesses/settings/confirm_email/#{token}")
      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/businesses/settings"
      assert %{"error" => message} = flash
      assert message == "Email change link is invalid or it has expired."
    end

    test "does not update email with invalid token", %{conn: conn, business: business} do
      {:error, redirect} = live(conn, ~p"/businesses/settings/confirm_email/oops")
      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/businesses/settings"
      assert %{"error" => message} = flash
      assert message == "Email change link is invalid or it has expired."
      assert BusinessAccounts.get_business_by_email(business.email)
    end

    test "redirects if business is not logged in", %{token: token} do
      conn = build_conn()
      {:error, redirect} = live(conn, ~p"/businesses/settings/confirm_email/#{token}")
      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/businesses/log_in"
      assert %{"error" => message} = flash
      assert message == "You must log in to access this page."
    end
  end
end
