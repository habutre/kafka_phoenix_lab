defmodule KafkaPhoenixLabWeb.PageController do
  use KafkaPhoenixLabWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
