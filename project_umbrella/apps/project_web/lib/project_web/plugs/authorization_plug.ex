defmodule ProjectWeb.Plugs.AuthorizationPlug do
    import Plug.Conn
    alias Project.UserContext.User
    alias Phoenix.Controller
    require ProjectWeb.Gettext
  
    def init(options), do: options
  
    def call(%{private: %{guardian_default_resource: %User{} = u}} = conn, roles) do
      conn
      |> grant_access(u.role in roles)
    end
  
    def grant_access(conn, true), do: conn
  
    def grant_access(conn, false) do
      translated = ProjectWeb.Gettext.dgettext "errors", "Unauthorized access"
      conn 
      |> Controller.put_flash(:error, translated)
      |> Controller.redirect(to: "/")
      |> halt
    end
  end