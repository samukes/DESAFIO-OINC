defmodule DesafioOinc.Repo.Migrations.CreateTableLesson do
  use Ecto.Migration

  def change do
    create table(:lessons, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :description, :string
      add :duration, :integer
      add :subject, :integer
      add :ocurrence, :date
      add :deleted_at, :naive_datetime

      add :lecturer_id, references("lecturers", type: :binary_id, column: :uuid)
      add :student_id, references("students", type: :binary_id, column: :uuid)

      timestamps()
    end
  end
end
