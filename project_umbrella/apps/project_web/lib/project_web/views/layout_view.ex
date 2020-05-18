defmodule ProjectWeb.LayoutView do
  use ProjectWeb, :view

  def new_locale(conn, locale, language_title) do
    "<a href=\"#{Routes.profile_path(conn, :profile_index, locale: locale)}\">#{language_title}</a>" |> raw
  end
end
