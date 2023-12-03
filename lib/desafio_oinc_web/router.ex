defmodule DesafioOincWeb.Router do
  use DesafioOincWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DesafioOincWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DesafioOincWeb do
    pipe_through :api
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: DesafioOincWeb.Schema

    forward "/", Absinthe.Plug, schema: DesafioOincWeb.Schema
  end

  scope "/", DesafioOincWeb do
    pipe_through :browser

    live "/lecturer", LecturerLive
    live "/student", StudentLive
  end
end
