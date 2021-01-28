defmodule AdvanceWeb.CategoryLive.Show do
  use AdvanceWeb, :live_view

  alias Advance.Basic

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(
        %{"id" => id, "page" => page, "per_page" => per_page, "filter" => filter},
        _,
        socket
      ) do
    {:noreply,
     socket
     |> assign(:page, page)
     |> assign(:per_page, per_page)
     |> assign(:filter, filter)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:category, Basic.get_category!(id))}
  end

  defp page_title(:show), do: "Show Category"
  defp page_title(:edit), do: "Edit Category"
end
