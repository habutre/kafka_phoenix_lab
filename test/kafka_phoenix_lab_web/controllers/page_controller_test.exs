defmodule KafkaPhoenixLabWeb.PageControllerTest do
  use KafkaPhoenixLabWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "scala-logo"
    assert html_response(conn, 200) =~ "elixir-logo"
  end
end
