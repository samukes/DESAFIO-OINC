defmodule DesafioOincWeb.Schema.LecturerTypes do
  use Absinthe.Schema.Notation

  alias DesafioOincWeb.Resolvers.LecturerResolver

  @desc "A lecturer of the school"
  object :lecturer do
    field :id, non_null(:id)
    field :name, :string
    field :age, :integer
  end

  object :lecturer_queries do
    @desc "List all lecturer"
    field :list_lecturers, list_of(:lecturer) do
      arg :only_deleted, :boolean

      resolve(&LecturerResolver.list_lecturers/3)
    end

    @desc "Get one lecturer"
    field :get_lecturer, :lecturer do
      arg(:id, non_null(:id))

      resolve(&LecturerResolver.get_lecture/3)
    end
  end

  object :lecturer_mutations do
    @desc "Create a lecturer"
    field :create_lecturer, type: :lecturer do
      arg(:name, non_null(:string))
      arg(:age, non_null(:integer))

      resolve(&LecturerResolver.create_lecturer/3)
    end

    @desc "Create a lecturer"
    field :update_lecturer, type: :lecturer do
      arg(:id, non_null(:id))
      arg(:name, :string)
      arg(:age, :integer)

      resolve(&LecturerResolver.update_lecturer/3)
    end

    @desc "Delete a lecturer"
    field :delete_lecturer, type: :success do
      arg(:id, non_null(:id))

      resolve(&LecturerResolver.delete_lecturer/3)
    end

    @desc "Restore a lecturer"
    field :restore_lecturer, type: :success do
      arg(:id, non_null(:id))

      resolve(&LecturerResolver.restore_lecturer/3)
    end
  end
end
