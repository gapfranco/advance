defmodule AdvanceWeb.Schema do
  use Absinthe.Schema

  alias AdvanceWeb.Schema

  # Add import types
  import_types(Absinthe.Type.Custom)

  # Types
  import_types(Schema.Types.SessionTypes)

  # Queries
  import_types(Schema.Queries.SessionQueries)

  # Mutations
  import_types(Schema.Mutations.SessionMutations)

  query do
    import_fields(:session_queries)
  end

  mutation do
    import_fields(:session_mutations)
  end
end
