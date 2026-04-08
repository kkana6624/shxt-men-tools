defmodule ShxtMenToolsWeb.PageController do
  use ShxtMenToolsWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
