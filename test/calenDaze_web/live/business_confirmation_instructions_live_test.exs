defmodule CalenDazeWeb.BusinessConfirmationInstructionsLiveTest do
  use CalenDazeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import CalenDaze.BusinessAccountsFixtures

  alias CalenDaze.BusinessAccounts
  alias CalenDaze.Repo

  setup do
    %{business: business_fixture()}
  end

  describe "Resend confirmation" do
    test "renders the resend confirmation page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/businesses/confirm")
      assert html =~ "Resend confirmation instructions"
    end

    test "sends a new confirmation token", %{conn: conn, business: business} do
      {:ok, lv, _html} = live(conn, ~p"/businesses/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", business: %{email: business.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.get_by!(BusinessAccounts.BusinessToken, business_id: business.id).context == "confirm"
    end

    test "does not send confirmation token if business is confirmed", %{conn: conn, business: business} do
      Repo.update!(BusinessAccounts.Business.confirm_changeset(business))

      {:ok, lv, _html} = live(conn, ~p"/businesses/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", business: %{email: business.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      refute Repo.get_by(BusinessAccounts.BusinessToken, business_id: business.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/businesses/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", business: %{email: "unknown@example.com"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.all(BusinessAccounts.BusinessToken) == []
    end
  end
end
