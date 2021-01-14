defmodule AdvanceWeb.Schema.Types.SessionTypes do
  use Absinthe.Schema.Notation
  # import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  # import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]

  @desc "User and token for the session"
  object :session_type do
    field(:token, :string)
    field(:user, :user_type)
  end

  @desc "New session signin"
  input_object :session_input_type do
    field(:email, non_null(:string))
    field(:password, non_null(:string))
  end

  @desc "User data"
  object :user_type do
    field(:id, :id)
    field(:name, :string)
    field(:email, :string)
    field(:is_blocked, :boolean)
  end
end
