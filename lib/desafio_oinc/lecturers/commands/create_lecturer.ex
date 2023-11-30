defmodule DesafioOinc.Lecturers.Commands.CreateLecturer do
  @derive Jason.Encoder
  defstruct [:uuid, :name, :age]

  use ExConstructor

  def assign_uuid(%__MODULE__{} = create_lecturer, uuid) do
    %__MODULE__{create_lecturer | uuid: uuid}
  end
end
