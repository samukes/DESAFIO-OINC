defmodule DesafioOinc.Factories.Lecturer do
  defmacro __using__(_opts) do
    quote do
      def lecturer_factory do
        %DesafioOinc.Studies.Projections.Lecturer{
          name: "Lecturer Name",
          age: 32
        }
      end
    end
  end
end
