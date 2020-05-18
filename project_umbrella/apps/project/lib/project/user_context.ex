defmodule Project.UserContext do
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, warn: false
  alias Project.Repo
  require Gettext
  alias Project.UserContext.User


  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  defdelegate get_acceptable_roles(), to: User

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def signup_user(attrs \\ %{}) do
    %User{}
    |> User.signup_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  
def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end


  def update_username(%User{} = user, attrs) do
    user 
    |> User.edit_username_changeset(attrs)
    |> Repo.update()
  end

  def update_password(%User{} = user, attrs) do
    edited_cs =      user     |> User.edit_password_changeset(attrs)
    edited_cs     |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def get_user(id), do: Repo.get(User, id)

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def authenticate_user(username, plain_text_password) do
    case Repo.get_by(User, username: username) do
      nil ->
        #translated = ProjectWeb.Gettext.dgettext("errors","invalid credential")
        Pbkdf2.no_user_verify()
        {:error, "invalid credentials"}

      user ->
        if Pbkdf2.verify_pass(plain_text_password, user.hashed_password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end
end
