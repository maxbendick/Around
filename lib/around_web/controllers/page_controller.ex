defmodule AroundWeb.PageController do
  use AroundWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
