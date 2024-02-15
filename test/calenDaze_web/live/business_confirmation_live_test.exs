defmodule CalenDazeWeb.BusinessConfirmationLiveTest do
  use CalenDazeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import CalenDaze.BusinessAccountsFixtures

  alias CalenDaze.BusinessAccounts
  alias CalenDaze.Repo

  setup do
    %{business: business_fixture()}
  end

  describe "Confirm business" do
    test "renders confirmation page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/businesses/confirm/some-token")
      assert html =~ "Confirm Account"
    end

    test "confirms the given token once", %{conn: conn, business: business} do
      token =
        extract_business_token(fn url ->
          BusinessAccounts.deliver_business_confirmation_instructions(business, url)
        end)

      {:ok, lv, _html} = live(conn, ~p"/businesses/confirm/#{token}")

      result =
        lv
        |> form("#confirmation_form")
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert {:ok, conn} = result

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "Business confirmed successfully"

      assert BusinessAccounts.get_business!(business.id).confirmed_at
      refute get_session(conn, :business_token)
      assert Repo.all(BusinessAccounts.BusinessToken) == []

      # when not logged in
      {:ok, lv, _html} = live(conn, ~p"/businesses/confirm/#{token}")

      result =
        lv
        |> form("#confirmation_form")
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert {:ok, conn} = result

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "Business confirmation link is invalid or it has expired"

      # when logged in
      conn =
        build_conn()
        |> log_in_business(business)

      {:ok, lv, _html} = live(conn, ~p"/businesses/confirm/#{token}")

      result =
        lv
        |> form("#confirmation_form")
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert {:ok, conn} = result
      refute Phoenix.Flash.get(conn.assigns.flash, :error)
    end

    test "does not confirm email with invalid token", %{conn: conn, business: business} do
      {:ok, lv, _html} = live(conn, ~p"/businesses/confirm/invalid-token")

      {:ok, conn} =
        lv
        |> form("#confirmation_form")
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "Business confirmation link is invalid or it has expired"

      refute BusinessAccounts.get_business!(business.id).confirmed_at
    end
  end
end
