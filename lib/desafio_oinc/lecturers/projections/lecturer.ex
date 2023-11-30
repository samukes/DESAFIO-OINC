defmodule DesafioOinc.Lecturers.Projections.Lecturer do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @derive {Phoenix.Param, key: :uuid}
  @fields ~w(uuid name age deleted_at)a

  schema "lecturers" do
    field :name, :string
    field :age, :integer
    field :deleted_at, :naive_datetime, default: nil

    timestamps()
  end

  def changeset(lecturer, attrs \\ %{}) do
    cast(lecturer, attrs, @fields)
  end
end
