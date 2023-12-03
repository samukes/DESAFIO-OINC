defmodule DesafioOincWeb.Schema do
  use Absinthe.Schema

  import_types DesafioOincWeb.Schema.LecturerTypes
  import_types DesafioOincWeb.Schema.StudentTypes
  import_types DesafioOincWeb.Schema.CommonTypes

  query do
    import_fields :lecturer_queries
    import_fields :student_queries
  end

  mutation do
    import_fields :lecturer_mutations
    import_fields :student_mutations
  end
end
