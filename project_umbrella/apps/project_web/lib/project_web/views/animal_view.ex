defmodule ProjectWeb.AnimalView do
    use ProjectWeb, :view
    def render("index.json", %{animals: animals}) do
      %{data: render_many(animals, __MODULE__, "animal.json")}
    end
  
    def render("show.json", %{animal: animal}) do
      %{data: render_one(animal, __MODULE__, "animal.json")}
    end
  
    def render("animal.json", %{animal: animal}) do
      %{id: animal.id, name: animal.name}
    end
  end