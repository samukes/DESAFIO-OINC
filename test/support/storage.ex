defmodule DesafioOinc.Storage do
  @doc """
  Clear the event store and read store databases
  """
  def reset! do
    Application.stop(:desafio_oinc)
    Application.stop(:commanded)

    reset_eventstore()

    {:ok, _} = Application.ensure_all_started(:desafio_oinc)

    reset_readstore()
  end

  defp reset_eventstore do
    config = DesafioOinc.EventStore.config()

    {:ok, conn} = config |> EventStore.Config.default_postgrex_opts() |> Postgrex.start_link()

    EventStore.Storage.Initializer.reset!(conn, config)
  end

  defp reset_readstore do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(DesafioOinc.Repo)

    Ecto.Adapters.SQL.Sandbox.mode(DesafioOinc.Repo, {:shared, self()})
  end
end
