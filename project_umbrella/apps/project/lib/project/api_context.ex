defmodule Project.ApiContext do
  alias Project.UserContext.User
  @moduledoc """
  The ApiContext context.
  """

  import Ecto.Query, warn: false
  alias Project.Repo

  alias Project.ApiContext.Api

  def create_key(attrs,%User{}=user) do
    %Api{}
    |> Api.create_changeset(attrs,user)
    |> Repo.insert()
end
  @doc """
  Returns the list of apis.

  ## Examples

      iex> list_apis()
      [%Api{}, ...]

  """
  def list_apis do
    Repo.all(Api)
  end

  def load_apis(user) do
    #  u = Guardian.Plug.current_resource(attrs)
     user |> Repo.preload([:apis])
  end

  @doc """
  Gets a single api.

  Raises `Ecto.NoResultsError` if the Api does not exist.

  ## Examples

      iex> get_api!(123)
      %Api{}

      iex> get_api!(456)
      ** (Ecto.NoResultsError)

  """
  def get_api!(id), do: Repo.get!(Api, id)
  def get_api(id,user) do

   api =Repo.get(Api, id)
   if api.user_id == user.id do
    {:ok,api}
   else
    {:error, "permission denied"}
   end
  end


  @doc """
  Creates a api.

  ## Examples

      iex> create_api(%{field: value})
      {:ok, %Api{}}

      iex> create_api(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_api(attrs, %User{} = user) do
    %Api{}
    |> Api.create_changeset(attrs, user)
    |> Repo.insert()
  end

  @doc """
  Updates a api.

  ## Examples

      iex> update_api(api, %{field: new_value})
      {:ok, %Api{}}

      iex> update_api(api, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_api(%Api{} = api, attrs) do
    api
    |> Api.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a api.

  ## Examples

      iex> delete_api(api)
      {:ok, %Api{}}

      iex> delete_api(api)
      {:error, %Ecto.Changeset{}}

  """
  def delete_api(%Api{} = api) do
    Repo.delete(api)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking api changes.

  ## Examples

      iex> change_api(api)
      %Ecto.Changeset{source: %Api{}}

  """
  def change_api(%Api{} = api) do
    Api.changeset(api, %{})
  end
end
