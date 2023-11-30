defmodule DesafioOinc.Repo.Migrations.CreateTableLecturer do
  use Ecto.Migration

  def change do
    create table :lecturers, primary_key: false do
      add :uuid, :binary_id, primary_key: true
      add :name, :string
      add :age, :integer
      add :deleted_at, :naive_datetime, default: nil

      timestamps()
    end
  end
end
