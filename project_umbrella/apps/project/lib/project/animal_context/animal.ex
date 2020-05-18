defmodule Project.AnimalContext.Animal do
  use Ecto.Schema
  import Ecto.Changeset
  
  alias Project.UserContext.User
  schema "animals" do
    field :name, :string
    field :animal, :string
    field :birthday, :date
    belongs_to :user, User
  end

# we willen enkel de dieren van de user en niet van andere users
  #def load_animals(%User{} = u), do: u |> Repo.preload([:animals])

  @doc false
  def changeset(animal, attrs) do
    animal
    |> cast(attrs, [:name,:animal,:birthday])
    |> validate_required([:name,:animal,:birthday])
  end

  def create_changeset(animal, attrs, user) do
    animal
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> put_assoc(:user, user)
  end
end
