defmodule ProjectWeb.SessionController do
    use ProjectWeb, :controller
  
    alias ProjectWeb.Guardian
    alias Project.UserContext
    alias Project.UserContext.User
  
    def new(conn, _) do
      changeset = UserContext.change_user(%User{})
      maybe_user = Guardian.Plug.current_resource(conn)
  
      if maybe_user do
        redirect(conn, to: "/user_scope")
      else
        render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
      end
    end
  
    def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
      UserContext.authenticate_user(username, password)
      |> login_reply(conn)
    end
  
    def logout(conn, _) do
      conn
      |> Guardian.Plug.sign_out()
      |> redirect(to: "/login")
    end
  
    defp login_reply({:ok, user}, conn) do
      translated = ProjectWeb.Gettext.dgettext("default", "Welcome back!")
      conn
      |> put_flash(:info,translated)
      |> Guardian.Plug.sign_in(user)
      |> redirect(to: "/useranimals")
    end
  
    defp login_reply({:error, reason}, conn) do
      conn
      |> put_flash(:error, to_string(reason))
      |> new(%{})
    end
    def signup(conn, _) do
      changeset = UserContext.change_user(%User{})
      roles = UserContext.get_acceptable_roles()
       render(conn, "formnonadmin.html", changeset: changeset, acceptable_roles: roles)
    end
  
    def signup_create(conn, %{"user" => params}) do
          case UserContext.signup_user(params) do
            {:ok, user} ->
              conn
              |> put_flash(:info, "User created successfully.")
              |> redirect(to: Routes.session_path(conn, :login))
      
              {:error, %Ecto.Changeset{} = changeset} -> 
                render(conn, "formnonadmin.html", changeset: changeset)
            
          end
    end

    
   
  
    def update(conn, %{ "user" => user_params}) do
      user = Guardian.Plug.current_resource(conn)
  
      case UserContext.update_user(user, user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: Routes.user_path(conn, :show, user.id))
  
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", user: user, changeset: changeset)
      end
    end
end