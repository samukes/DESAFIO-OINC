defmodule DesafioOinc.Studies.Projections.Lecturer do
  use Ecto.Schema

  import Ecto.Changeset

  alias DesafioOinc.Studies.Projections.Lesson

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @derive {Phoenix.Param, key: :uuid}
  @fields ~w(uuid name age deleted_at)a
  @required_fields ~w(name age)a

  schema "lecturers" do
    field :name, :string
    field :age, :integer
    field :deleted_at, :naive_datetime, default: nil

    has_many :lessons, Lesson, foreign_key: :lecturer_id, references: :uuid
    has_many :students, through: [:lessons, :student]

    timestamps()
  end

  def changeset(lecturer, attrs \\ %{}) do
    lecturer
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
