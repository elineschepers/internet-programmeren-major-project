defmodule Project.ApiContext.Api do
  alias Project.UserContext.User
  use Ecto.Schema
  import Ecto.Changeset

  schema "apis" do
    field :key, :string
    field :name, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(api, attrs) do
    api
    |> cast(attrs, [:name, :key])
    |> validate_required([:name, :key])
  end

  def create_changeset(api,attrs,user) do
  
    api
    |> cast(attrs,[:name])
    |> validate_required([:name])
    |> put_assoc(:user, user)
    |> add_key()
  end

  defp add_key(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{name: name}} ->
        put_change(changeset, :key, generate_key(32))
        _->
        changeset
    end
   end
    
  defp generate_key(length)do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
