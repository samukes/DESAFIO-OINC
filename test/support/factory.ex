defmodule DesafioOinc.Factory do
  use ExMachina.Ecto, repo: DesafioOinc.Repo

  use DesafioOinc.Factories.Lecturer
end
