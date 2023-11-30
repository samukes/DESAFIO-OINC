defmodule DesafioOincWeb.Router do
  use DesafioOincWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DesafioOincWeb do
    pipe_through :api
  end
end
