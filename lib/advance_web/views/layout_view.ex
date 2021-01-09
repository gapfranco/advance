defmodule AdvanceWeb.LayoutView do
  use AdvanceWeb, :view

  def avatar(user) do
    with %{original: url} <- Advance.Avatar.urls({user.avatar, user}) do
      url
    else
      _ -> nil
    end
  end
end
