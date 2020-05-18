defmodule Project.Repo.Migrations.CreateApis do
  use Ecto.Migration

  def change do
    create table(:apis) do
      add :name, :string, null: false
      add :key, :string, null:false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end

  end
end
