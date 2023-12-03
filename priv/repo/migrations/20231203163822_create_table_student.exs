defmodule DesafioOinc.Repo.Migrations.CreateTableStudent do
  use Ecto.Migration

  def change do
    create table(:students, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :name, :string
      add :age, :integer
      add :deleted_at, :naive_datetime

      timestamps()
    end
  end
end
