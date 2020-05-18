defmodule ProjectWeb.ProfileView do
    use ProjectWeb, :view

  @me __MODULE__

    def render("show.json", %{animals: as}), do: render_many(as, @me, "single-animal.json", as: :animal)

    def render("single-animal.json", %{animal: a}), do: %{id: a.id, name: a.name}
  end