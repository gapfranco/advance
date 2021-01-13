defmodule AdvanceWeb.UserProfileControllerTest do
  use AdvanceWeb.ConnCase, async: true

  setup :register_and_log_in_user

  import Advance.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "GET /users/update_profile" do
    test "renders profile in page", %{conn: conn} do
      conn = get(conn, Routes.user_settings_path(conn, :update_profile))
      response = html_response(conn, 200)
      assert response =~ "Profile"
    end
  end

  describe "PUT /users/update_profile" do
    test "change user name", %{conn: conn, user: user} do
      conn =
        put(conn, Routes.user_settings_path(conn, :update_profile), %{
          "user" => %{"email" => user.email, "name" => "new name"}
        })

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)

      assert response =~ "Profile updated"
    end
  end
end
