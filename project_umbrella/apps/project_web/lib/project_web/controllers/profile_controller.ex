defmodule ProjectWeb.ProfileController do

    use ProjectWeb, :controller
    alias Project.UserContext
    alias Project.UserContext.User
    alias Project.AnimalContext
    alias Project.AnimalContext.Animal
    alias Project.ApiContext.Api
    alias Project.ApiContext
    def profile(conn, _params) do
        user = Guardian.Plug.current_resource(conn)
        loaded_user = user |> ApiContext.load_apis()
        changeset = ApiContext.change_api(%Api{})
        #render komt van :controller zie bovenaan use
        render(conn, "profile.html", user: loaded_user, changeset: changeset)
      
    end

    def profile_index(conn, _params) do
        user = Guardian.Plug.current_resource(conn)
        loaded_user = user |> AnimalContext.load_animals()
  
        render(conn, "user_animals.html", user: loaded_user)
      
    end

    def profile_index_with_id(conn,%{"user_id"=>uw_id}) do
        user = UserContext.get_user!(uw_id)
        loaded_user = user |> AnimalContext.load_animals()
  
        render(conn, "show.json", animals: loaded_user.animals)
      
    end

    def generate_key(conn, %{"api" => api_params}) do
      require IEx
      #IEx.pry
      user = Guardian.Plug.current_resource(conn)

      if api_params["name"] == "" do
        translated1 = ProjectWeb.Gettext.dgettext("error", "Api name can't be empty")
        conn
          |> put_flash(:error, translated1)
          |> redirect(to: Routes.profile_path(conn, :profile))
      end
      case ApiContext.create_api(api_params, user) do
          {:ok, %Api{} = api} ->
          translated = ProjectWeb.Gettext.dgettext("default", "Api key created.")
          conn
          |> put_flash(:info, translated)
          |> redirect(to: Routes.profile_path(conn, :profile))
  
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "profile.html", user: user, changeset: changeset)
      end
    
    end

    def show_key(conn, %{"id" => id}) do

      user = Guardian.Plug.current_resource(conn) 
     
         case ApiContext.get_api(id,user) do
           {:ok, %Api{} = api} ->
            render(conn, "show_key.html", api: api)
            {:error, _cs} ->
              conn
              |> send_resp(401, _cs)
          end
        
        
            
    end

    def delete_key(conn, %{"id" => id}) do 

      api = ApiContext.get_api!(id)
      user = Guardian.Plug.current_resource(conn)
      {:ok, _id}= ApiContext.delete_api(api)
      # ApiContext.delete_api(api)

      translated = ProjectWeb.Gettext.dgettext("default","api deleted successfully.")
      conn
      |> put_flash(:info, translated)
      |> redirect(to: Routes.profile_path(conn, :profile))
    end


    def go_edit_username(conn, _params) do
        user = Guardian.Plug.current_resource(conn)
        changeset = UserContext.change_user(user)
        render(conn, "edit_username.html", user: user,edit_username_changeset: changeset)
      end
    
      def go_edit_password(conn,_params) do
        user = Guardian.Plug.current_resource(conn)
        changeset = UserContext.change_user(user)
        render(conn, "edit_password.html", user: user, edit_password_changeset: changeset)
      end
    
      def update_username(conn, %{ "user" => user_params}) do
        user = Guardian.Plug.current_resource(conn)
        case UserContext.update_username(user, user_params) do
          {:ok, user} ->
            translated = ProjectWeb.Gettext.dgettext("default","username Updated successfully.")
            conn
            |> put_flash(:info,translated)
            |> redirect(to: Routes.profile_path(conn, :profile))
    
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit_username.html", user: user, changeset: changeset)
        end
      end
    
      def update_password(conn, %{ "user" => user_params}) do
        user = Guardian.Plug.current_resource(conn)
        case UserContext.update_password(user, user_params) do
          {:ok, user} ->
            translated = ProjectWeb.Gettext.dgettext("default","password Updated successfully.")
            conn
            |> put_flash(:info,translated)
            |> redirect(to: Routes.profile_path(conn, :profile))
    
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit_password.html", user: user, edit_password_changeset: changeset)
        end
      end
end