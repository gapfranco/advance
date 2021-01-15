defmodule AdvanceWeb.Schema.Mutations.SessionMutations do
  use Absinthe.Schema.Notation

  alias AdvanceWeb.Schema.Resolvers
  # alias AdvanceWeb.Schema.Middleware

  object :session_mutations do
    @desc "Connect user, returning a JWT token"
    field :signin, type: :session_type do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.SessionResolvers.login_user/3)
    end

    @desc "SignUp a new user"
    field :signup, type: :user_type do
      arg(:email, non_null(:string))
      arg(:name, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.SessionResolvers.signup_user/3)
    end

    # @desc "Forgot password - send e-mail to reset"
    # field :forgot_password, type: :message_type do
    #   arg(:uid, non_null(:string))
    #   resolve(&Resolvers.SessionResolvers.forgot_password/3)
    # end

    # @desc "Create new password"
    # field :create_password, type: :message_type do
    #   arg(:input, non_null(:create_password_input_type))
    #   resolve(&Resolvers.SessionResolvers.create_password/3)
    # end

    # @desc "Change password"
    # field :change_password, type: :message_type do
    #   arg(:old_password, non_null(:string))
    #   arg(:password, non_null(:string))
    #   arg(:password_confirmation, non_null(:string))
    #   middleware(Middleware.Authorize, :any)
    #   resolve(&Resolvers.SessionResolvers.change_password/3)
    # end
  end
end
