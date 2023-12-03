defmodule DesafioOinc.Studies.Projections.Student do
  use Ecto.Schema

  import Ecto.Changeset

  alias DesafioOinc.Studies.Projections.Lesson

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @derive {Phoenix.Param, key: :uuid}
  @fields ~w(uuid name age deleted_at)a
  @required_fields ~w(name age)a

  schema "students" do
    field :name, :string
    field :age, :integer
    field :deleted_at, :naive_datetime, default: nil

    belongs_to :lesson, Lesson, references: :uuid
    has_many :lessons, Lesson, foreign_key: :uuid, references: :lesson_id
    has_many :lecturers, through: [:lessons, :lecturer]

    timestamps()
  end

  def changeset(student, attrs \\ %{}) do
    student
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
