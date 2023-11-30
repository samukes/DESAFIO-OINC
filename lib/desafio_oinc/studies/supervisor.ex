defmodule DesafioOinc.Studies.Supervisor do
  use Supervisor

  alias DesafioOinc.Studies.Projectors.Lecturer, as: LecturerProjectorWorker

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_) do
    Supervisor.init(
      [
        LecturerProjectorWorker
      ],
      strategy: :one_for_one
    )
  end
end
