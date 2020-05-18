defmodule ProjectWeb.Router do
  use ProjectWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ProjectWeb.Plugs.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ProjectWeb.Pipeline
  end

  pipeline :verify_api_token do
    plug ProjectWeb.Plugs.ApiPlug
  end
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :allowed_for_users do
    plug ProjectWeb.Plugs.AuthorizationPlug, ["Admin", "Manager", "User"]
  end

  pipeline :allowed_for_managers do
    plug ProjectWeb.Plugs.AuthorizationPlug, ["Admin", "Manager"]
  end

  pipeline :allowed_for_admins do
    plug ProjectWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  scope "/", ProjectWeb do
    pipe_through [:browser,:auth]

    get "/", SessionController, :new
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
    get "/signup", SessionController, :signup
    post "/signup", SessionController, :signup_create
    
    
  end

  scope "/", ProjectWeb do
    pipe_through [:browser,:auth, :ensure_auth]

    
    get "/useranimals", ProfileController, :profile_index
    get "/editusername", ProfileController, :go_edit_username
    put "/editusername", ProfileController, :update_username
    get "/editpassword", ProfileController, :go_edit_password
    put "/editpassword", ProfileController, :update_password
    get "/profile", ProfileController, :profile
  end
  scope "/",ProjectWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]

    get "/user_scope",ProfileController, :profile_index
    
  end

  scope "/", ProjectWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_managers]

    get "/manager_scope", ProfileController, :profile_index
  end

  scope "/admin", ProjectWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]
    resources "/users", UserController
    get "/", PageController, :admin_index
    get "/users/:id", UserController, :show
    get "/users/:id/edit", UserController, :edit
    put "/users/:id/edit", UserController, :update
  end

  # scope "/", ProjectWeb do
  #   pipe_through [:browser, :auth]

  #   get "/animals/new", AnimalController, :new
  #   post "/animals", AnimalController, :create
  #   get "/animals", AnimalController, :index
  #   get "/animals/:animal_id", AnimalController, :show
    
  #   get "/animals/:animal_id/edit", AnimalController, :edit
  #   put "/animals/:animal_id", AnimalController, :update
  #   patch "/animals/:animal_id", AnimalController, :update
  #   delete "/animals/:animal_id", AnimalController, :delete
  # end
"""
  scope "/" -> resources "/users" => is for the html interface to edit our users.
  scope "/api" -> resources "/users", only: [] => means that we're generating routes for our user as well. Thanks to the resources macro, we can configure this and say that we don't want REST routes for the users resource.
  resources "/cats", CatController => means that we're going to allow (nested if it is inside another resources block) cat routes for our REST API.
  """
scope "/profile", ProjectWeb do
  pipe_through [:browser, :auth, :ensure_auth]

  post "/newkey", ProfileController, :generate_key
  get "/showkey/:id", ProfileController, :show_key
  delete "/deletekey/:id", ProfileController, :delete_key
  #get "/apilink", ProfileController, :api_link
  end  

scope "/api/user/:user_id", ProjectWeb do
 pipe_through [:api,:verify_api_token]
  post "/new", AnimalController, :create
  put "/update/:id", AnimalController, :update
  delete "/delete/:id", AnimalController, :delete
  get "/animals/:id", AnimalController, :show
  get "/animals", ProfileController, :profile_index_with_id
 
end



  # Other scopes may use custom stacks.
  # scope "/api", ProjectWeb do
  #   pipe_through :api
  # end
  end