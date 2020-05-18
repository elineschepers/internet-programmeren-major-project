defmodule Project.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Project.AnimalContext.Animal
  alias Project.ApiContext.Api
  
  @acceptable_roles ["Admin", "Manager", "User"]
  schema "users" do
    field :current_password_in_text_passed_from_form, :string, virtual: true
    field :new_password, :string, virtual: true
    field :new_password_confirmation, :string, virtual: true
    field :username, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :role, :string, default: "User"
    has_many :animals, Animal
    has_many :apis, Api
  end

  def get_acceptable_roles, do: @acceptable_roles


  @doc false
  def changeset(user, attrs) do
    user
        |> cast(attrs, [:username, :password, :role])
    |> validate_required([:username, :password, :role])
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()
  end

  @doc false
  def edit_username_changeset(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
  end

  @doc false
  def edit_password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password, :new_password, :new_password_confirmation])
    |> validate_required([:password, :new_password, :new_password_confirmation])
    |> validate_confirmation(:new_password)
    |> validate_change(:password, fn :password, plain_text_pwd ->
      case Pbkdf2.verify_pass(plain_text_pwd, user.hashed_password) do
        true -> []
        false -> [password: "Invalid password."]
      end
    end)
    |> update_password_hash()
  end

  def signup_changeset(user, attrs) do
# => geen role van client side toelaten, zelf "user" role enforcen
# %User{role: "user"}
  new_attrs = Map.put(attrs, "role", "user")

  user
  |> cast(new_attrs, [:username, :password, :new_password_confirmation])
  |> validate_required([:username, :password, :role])
  |> validate_inclusion(:role, @acceptable_roles)
  |> put_password_hash()
  |> validate_confirmation(:password)
  |> unique_constraint(:username )
  end

  
  defp put_password_hash(
    %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
  ) do
change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
end

defp update_password_hash(
    %Ecto.Changeset{valid?: true, changes: %{new_password: password}} = changeset
  ) do
change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
end

defp update_password_hash(changeset), do: changeset

defp put_password_hash(changeset), do: changeset
end

