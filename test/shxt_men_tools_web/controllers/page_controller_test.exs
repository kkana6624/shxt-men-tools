defmodule ShxtMenToolsWeb.PageControllerTest do
  use ShxtMenToolsWeb.ConnCase

  test "GET / redirects to login if unauthenticated", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert redirected_to(conn) == ~p"/users/log-in"
  end

  test "GET / renders home page if authenticated", %{conn: conn} do
    user = ShxtMenTools.AccountsFixtures.user_fixture()
    conn = conn |> log_in_user(user) |> get(~p"/")
    assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end
end
