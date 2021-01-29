defmodule AdvanceWeb.CategoryLive.Index do
  use AdvanceWeb, :live_view

  alias Advance.Basic
  alias Advance.Basic.Category

  @impl true
  def mount(_params, _session, socket) do
    ### REAL-TIME
    # if connected?(socket), do: Basic.subscribe()

    socket = assign(socket, categories: [])
    {:ok, socket}
    # {:ok, assign(socket, :categories, list_categories())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    page = param_to_integer(params["page"] || "1", 1)
    per_page = param_to_integer(params["per_page"] || "8", 8)
    filter = params["filter"] || ""
    socket = prepare_params(socket, page, per_page, filter)

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def prepare_params(socket, page, per_page, filter) do
    sort_by = :name
    sort_order = :asc
    sort_options = %{sort_by: sort_by, sort_order: sort_order}
    paginate_options = %{page: page, per_page: per_page}

    result =
      Basic.list_categories(
        paginate: paginate_options,
        sort: sort_options,
        filter: filter
      )

    categories = result.list
    total = ceil(result.total / per_page)
    paginate_options = Map.put(paginate_options, :total, total)

    socket
    |> assign(
      categories: categories,
      options: Map.merge(paginate_options, sort_options),
      filter: filter
    )
  end

  defp param_to_integer(param, default_value) do
    case Integer.parse(param) do
      {0, _} ->
        1

      {number, _} ->
        number

      :error ->
        default_value
    end
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Category")
    |> assign(:category, Basic.get_category!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Category")
    |> assign(:category, %Category{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Categories")
    |> assign(:category, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    category = Basic.get_category!(id)
    {:ok, _} = Basic.delete_category(category)

    {:noreply, assign(socket, :categories, [])}
  end

  # def handle_event("filter", %{"filter" => filter}, socket) do
  def handle_event("filter", %{"filter" => filter}, socket) do
    socket = prepare_params(socket, 1, 8, filter)

    {:noreply, socket}
  end

  defp pagination_link(socket, text, page, options, filter) do
    live_patch(text,
      to:
        Routes.category_index_path(socket, :index, page: page, per_page: options, filter: filter)
    )
  end

  defp render_next() do
    assigns = %{:__changed__ => ""}

    ~L"""
    <!-- Heroicon name: chevron-right -->
    <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
      <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
    </svg>
    """
  end

  defp render_prev() do
    assigns = %{:__changed__ => ""}

    ~L"""
    <!-- Heroicon name: chevron-left -->
    <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
      <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
    </svg>
    """
  end

  ### REAL_TIME
  # @impl true
  # def handle_info({:category_created, category}, socket) do
  #   socket = update(socket, :categories, fn categories -> [category | categories] end)
  #   {:noreply, socket}
  # end

  # @impl true
  # def handle_info({:category_updated, category}, socket) do
  #   socket = update(socket, :categories, fn categories -> [category | categories] end)
  #   {:noreply, socket}
  # end
end
