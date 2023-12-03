defmodule DesafioOincWeb.Schema.StudentTypes do
  use Absinthe.Schema.Notation

  alias DesafioOincWeb.Resolvers.StudentResolver

  @desc "A student of the school"
  object :student do
    field :id, non_null(:id)
    field :name, :string
    field :age, :integer
  end

  object :student_queries do
    @desc "List all student"
    field :list_students, list_of(:student) do
      arg :only_deleted, :boolean

      resolve(&StudentResolver.list_students/3)
    end

    @desc "Get one student"
    field :get_student, :student do
      arg(:id, non_null(:id))

      resolve(&StudentResolver.get_student/3)
    end
  end

  object :student_mutations do
    @desc "Create a student"
    field :create_student, type: :student do
      arg(:name, non_null(:string))
      arg(:age, non_null(:integer))

      resolve(&StudentResolver.create_student/3)
    end

    @desc "Create a student"
    field :update_student, type: :student do
      arg(:id, non_null(:id))
      arg(:name, :string)
      arg(:age, :integer)

      resolve(&StudentResolver.update_student/3)
    end

    @desc "Delete a student"
    field :delete_student, type: :success do
      arg(:id, non_null(:id))

      resolve(&StudentResolver.delete_student/3)
    end

    @desc "Restore a student"
    field :restore_student, type: :success do
      arg(:id, non_null(:id))

      resolve(&StudentResolver.restore_student/3)
    end
  end
end
