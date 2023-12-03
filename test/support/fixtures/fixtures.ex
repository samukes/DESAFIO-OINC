defmodule DesafioOinc.Fixtures do
  use DesafioOinc.Fixtures.Aggregates.Lecturer
  use DesafioOinc.Fixtures.Aggregates.Student

  use DesafioOinc.Fixtures.Graphql.Lecturer
  use DesafioOinc.Fixtures.Graphql.Student
end
