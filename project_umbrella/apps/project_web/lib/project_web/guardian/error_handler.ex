defmodule ProjectWeb.ErrorHandler do
    import Plug.Conn
    alias Project.UserContext.User
    alias Phoenix.Controller
    require ProjectWeb.Gettext
    @behaviour Guardian.Plug.ErrorHandler
  
    @impl Guardian.Plug.ErrorHandler
    def auth_error(conn, {type, _reason}, _opts) do
      # body = Jason.encode!(%{message: to_string(type)})
       #send_resp(conn, 401, body)

       translated = ProjectWeb.Gettext.dgettext "errors", "Unauthorized access"
      conn 
      |> Controller.put_flash(:error, translated)
      |> Controller.redirect(to: "/login")
    end
  end