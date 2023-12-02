defmodule DesafioOincWeb.Schema.CommonTypes do
  use Absinthe.Schema.Notation

  @desc "A success message"
  object :success do
    field :message, non_null(:string)
  end
end
