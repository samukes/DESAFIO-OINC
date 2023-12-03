defmodule DesafioOinc.Studies.Commands.UpdateLecturer do
  @derive Jason.Encoder
  defstruct [:uuid, :name, :age]

  use ExConstructor

  def assign_changes(%__MODULE__{} = update, changes) do
    name = Map.get(changes, :name, update.name)
    age = Map.get(changes, :age, update.age)

    %__MODULE__{update | name: name, age: age}
  end
end
