defmodule Project.Repo.Migrations.CreateAnimals do
  use Ecto.Migration
  def change do
    create table(:animals) do
      add :name, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :birthday, :date, null: false
      add :animal, :string, null: false
    end

    # create index(:animals, [:user])
  end
end
