defmodule DesafioOinc.Lecturers.Aggregates.Lecturer do
  @derive Jason.Encoder
  defstruct [:uuid, :name, :age]

  alias DesafioOinc.Lecturers.Commands.CreateLecturer

  alias DesafioOinc.Lecturers.Events.LecturerCreated

  def execute(%__MODULE__{uuid: nil}, %CreateLecturer{} = create) do
    %LecturerCreated{
      uuid: create.uuid,
      name: create.name,
      age: create.age
    }
  end

  def apply(%__MODULE__{} = lecturer, %LecturerCreated{} = created) do
    %__MODULE__{
      lecturer
      | uuid: created.uuid,
        name: created.name,
        age: created.age
    }
  end
end
