defmodule ProjectWeb.Plugs.ApiPlug do

    alias Project.UserContext.User
    alias Project.UserContext
    alias Project.ApiContext
    require ProjectWeb.Gettext
    import Plug.Conn
    def init(options), do: options
#%{private: %{guardian_default_resource: %User{} = u}} = 
def call(conn, apis) do
  userid = Map.get(conn.params, "user_id")
  user = UserContext.get_user(userid)
  user_with_apis = ApiContext.load_apis(user)
  [response|tail] = get_req_header(conn, "apikey")
  
  
  access = contains(response, user_with_apis.apis)
  
    conn
  #response[0] in u.apis
    |> grant_access(access)
  end

  def contains(api, apis) do
    # foreach(u_api in apis){check of u_api.key gelijk is met api param}
     Enum.any?(apis, fn u_api -> u_api.key == api end)
  end

  def grant_access(conn, true), do: conn

  def grant_access(conn, false) do
    translated = ProjectWeb.Gettext.dgettext "errors", "Unauthorized access"
    conn 
    |> send_resp(400, translated)
    |> halt
  end
end
