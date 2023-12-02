defmodule DesafioOincWeb.Router do
  use DesafioOincWeb, :router

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
end
