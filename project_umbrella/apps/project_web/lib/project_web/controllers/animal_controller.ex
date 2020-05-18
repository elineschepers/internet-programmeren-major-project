defmodule ProjectWeb.AnimalController do
    use ProjectWeb, :controller
    alias Project.UserContext.User
    alias Project.UserContext
    alias Project.AnimalContext
    alias Project.AnimalContext.Animal

    def profile_index(conn, _params) do
      user = Guardian.Plug.current_resource(conn)
      loaded_user = user |> AnimalContext.load_animals()

      render(conn, "user_animals.html", user: loaded_user)
    end
  
    def new(conn, _parameters) do
      changeset = AnimalContext.change_animal(%Animal{})
      render(conn, "new.html", changeset: changeset)
    end
  
    #def create(conn, %{ %{"animal"=>animal},%{"name"=>name},%{"birtday"=>birtday},%{"id"=>id} => animal_params}},"user_id" => user_id}) do
      def create(conn, %{"animal"=>animal_params,"user_id" => user_id}) do
      
        user = UserContext.get_user(user_id)
        require IEx
        IEx.pry
      case AnimalContext.create_animal(animal_params,user) do
        {:ok, %Animal{}= animal} ->
          conn
          |> put_status(:created)
          |> put_resp_header("location",Routes.animal_path(conn, :show, user, animal))
          |> render("show.json", animal: animal)
  
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end

    
    #eerst retrieven we de user en laden daarna zijn animals
    def index(conn, _params) do
      
      user = Guardian.Plug.current_resource(conn)
      #if user == nil, do: raise "not authenticated, custom error"
      user_with_loaded_animals = AnimalContext.load_animals(user)
      render(conn, "index.json", animals: user_with_loaded_animals.animals)
    end
    
    def show(conn, %{"id" => id,"user_id" => user_id}) do
     require IEx
     IEx.pry
     #user_id=conn.params.user_id
     user = UserContext.get_user(user_id)
    case AnimalContext.get_animal(id,user) do
        {:ok, %Animal{} = animal} ->
         render(conn, "show.json", animal: animal)
         {:error, _cs} ->
           conn
           |> send_resp(401, _cs)
       end
    end

      def edit(conn, %{"animal_id" => id}) do
        animal = AnimalContext.get_animal!(id)
        changeset = AnimalContext.change_animal(animal)
        render(conn, "edit.html", animal: animal, changeset: changeset)
      end
    
      def update(conn, %{"id" => id, "animal" => animal_params,"user_id" => user_id}) do

       
        user = UserContext.get_user(user_id)
        animal = AnimalContext.get_animal!(id)
        require IEx
        #IEx.pry
        #authorize moet of wel :ok als het in orde is teruggeven en anders :nok
        with {:auth, {:ok}} <- {:auth,  AnimalContext.authorize(id,user_id)},
        {:update, {:ok, %Animal{} = a}} <- {:update, AnimalContext.update_animal(animal,animal_params,user)} do
          render(conn, "show.json", animal: animal)
          # execute final code here, such as send a 200 OK response
        else
            {:auth, {:nok}} -> conn |> send_resp(400,"you're not authorized")
            {:update, {:error, err}} when is_binary(err) -> conn |> send_resp(401,err)
            {:update, {:error, %Ecto.Changeset{} = _changeset, errors, data,false}} when is_binary(_changeset) -> conn |> send_resp(403, _changeset)
        end
       
        # case AnimalContext.update_animal(animal, animal_params,user) do
        #   {:ok, %Animal{} = animal} ->
        #     render(conn, "show.json", animal: animal)
    
        #   {:error, error} when is_binary(error) or is_atom(error)->
        # conn
        #     |> send_resp(400, error)
        #   {:error, %Ecto.Changeset{} = _changeset} ->
        #     conn |> send_resp(401, "fields incorrect or something")
        #   end
      end

      def delete(conn, %{"id" => id,"user_id" => user_id}) do 

        # animal = AnimalContext.get_animal!(id)

        user = UserContext.get_user(user_id)
        case AnimalContext.delete_animal(id,user) do
          {:ok} ->
            send_resp(conn, :no_content, "")
           {:error, _cs} ->
             conn
             |> send_resp(401, _cs)
         end
        # with {:ok, %Animal{}} <- AnimalContext.delete_animal(animal) do
        #   send_resp(conn, :no_content, "")
        conn
        |> put_flash(:info, "Animal deleted successfully.")
        |> redirect(to: Routes.animal_path(conn, :index))
      end
    
  end