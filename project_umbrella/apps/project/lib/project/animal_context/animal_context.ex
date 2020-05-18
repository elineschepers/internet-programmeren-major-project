defmodule Project.AnimalContext do
    alias Project.AnimalContext.Animal
    alias Project.Repo
    alias Project.UserContext.User
    @doc "Returns a animal changeset"
    def change_animal(%Animal{} = animal) do
      animal |> Animal.changeset(%{})
    end
  
    @doc "Creates a animal based on some external attributes"
    def create_animal(%Animal{}=animal,%User{}=user) do
      
      #user = Guardian.Plug.current_resource(attrs)
      %Animal{}
      |> Animal.create_changeset(animal, user)
      |> Repo.insert()
    
    end
     @doc "Returns a specific animal or raises an error"
  def get_animal!(id), do: Repo.get!(Animal, id)

  def get_animal(id,user) do

    animal =Repo.get(Animal, id)
    if animal.user_id == user.id do
     {:ok,animal}
    else
     {:error, "permission denied"}
    end
   end

  @doc "Returns all animals in the system"
  def list_animals, do: Repo.all(Animal)

   
  
  def authorize(id, user_id) do
    
    if user_id == id do
      {:ok}
    else
      {:nok}
    end

  end


  @doc "Update an existing animal with external attributes"
  def update_animal(%Animal{} = animal, attrs,user) do

    #  if animal.user_id == user.id do
      animal
      |> Animal.changeset(attrs)
      |> Repo.update()
      # {:ok,animal}
    #  else
      # {:error, "permission denied"}
    #  end
    
  end

  def load_animals(user) do
    #  u = Guardian.Plug.current_resource(attrs)
     user |> Repo.preload([:animals])
  end

  
 @doc "Delete a animal"
 def delete_animal(%Animal{} = animal), do: Repo.delete(animal)

 def delete_animal(id,user) do

  animal =Repo.get(Animal, id)
  if animal.user_id == user.id do
    Repo.delete(animal)
   {:ok}
  else
   {:error, "permission denied"}
  end
 end

end

  