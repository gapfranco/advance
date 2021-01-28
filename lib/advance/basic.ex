defmodule Advance.Basic do
  @moduledoc """
  The Basic context.
  """

  import Ecto.Query, warn: false
  alias Advance.Repo

  alias Advance.Basic.Category

  ### REAL-TIME
  # def subscribe do
  #   Phoenix.PubSub.subscribe(Advance.PubSub, "categories")
  # end

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  def list_categories(criteria) when is_list(criteria) do
    query = from(d in Category)

    query =
      Enum.reduce(criteria, query, fn
        {:filter, ""}, query ->
          query

        {:filter, filter}, query ->
          pattern = "#{filter}%"

          from q in query,
            where: ilike(q.name, ^pattern)

        _, query ->
          query
      end)

    sub_query = from(t in subquery(query), select: count("*"))
    count = Repo.one(sub_query)

    query =
      Enum.reduce(criteria, query, fn
        {:paginate, %{page: page, per_page: per_page}}, query ->
          from q in query,
            offset: ^((page - 1) * per_page),
            limit: ^per_page

        {:filter, ""}, query ->
          query

        {:filter, filter}, query ->
          pattern = "#{filter}%"

          from q in query,
            where: ilike(q.name, ^pattern)

        {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
          from q in query, order_by: [{^sort_order, ^sort_by}]

        _, query ->
          query
      end)

    list = Repo.all(query)
    %{list: list, total: count}
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()

    ### REAL-TIME
    # |> broadcast(:category_created)
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()

    ### REAL-TIME
    # |> broadcast(:category_updated)
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  ### REAL-TIME
  # def broadcast({:ok, category}, event) do
  #   Phoenix.PubSub.broadcast(Advance.PubSub, "categories", {event, category})
  #   {:ok, category}
  # end

  # def broadcast({:error, _reason} = error, _event), do: error
end
