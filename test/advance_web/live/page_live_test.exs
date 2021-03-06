defmodule AdvanceWeb.PageLiveTest do
  use AdvanceWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to Advance"
    assert render(page_live) =~ "Welcome to Advance"
  end
end
