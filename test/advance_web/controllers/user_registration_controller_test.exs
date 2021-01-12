defmodule AdvanceWeb.UserRegistrationControllerTest do
  use AdvanceWeb.ConnCase, async: true

  import Advance.AccountsFixtures

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "Register"
      assert response =~ "Log in"
      assert response =~ "Log in"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "email" => email,
            "password" => valid_user_password(),
            "name" => valid_name()
          }
        })

      assert redirected_to(conn) =~ "/users/log_in"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{"email" => "with spaces", "password" => "123"}
        })

      response = html_response(conn, 200)
      assert response =~ "Register"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should have 6 to 80 character(s)"
    end
  end
end
