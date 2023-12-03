defmodule DesafioOinc.Studies.Projections.Lesson do
  use Ecto.Schema

  import Ecto.Changeset

  alias DesafioOinc.Studies.Projections.{Lecturer, Student}

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @derive {Phoenix.Param, key: :uuid}
  @fields ~w(uuid name age deleted_at)a
  @required_fields ~w(name age)a

  schema "lessons" do
    field :description, :string
    field :duration, :integer
    field :subject, :integer
    field :ocurrence, :date
    field :deleted_at, :naive_datetime, default: nil

    has_one :lecturer, Lecturer, foreign_key: :uuid
    has_one :student, Student, foreign_key: :uuid

    timestamps()
  end

  def changeset(lesson, attrs \\ %{}) do
    lesson
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
