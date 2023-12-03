defmodule DesafioOinc.Studies.Aggregates.Student do
  @derive Jason.Encoder
  defstruct [:uuid, :name, :age, deleted_at: nil]

  use ExConstructor

  alias DesafioOinc.Studies.Commands.{
    CreateStudent,
    DeleteStudent,
    RestoreStudent,
    UpdateStudent
  }

  alias DesafioOinc.Studies.Events.{
    StudentCreated,
    StudentDeleted,
    StudentRestored,
    StudentNameUpdated,
    StudentAgeUpdated
  }

  def execute(%__MODULE__{uuid: nil}, %CreateStudent{} = create) do
    %StudentCreated{
      uuid: create.uuid,
      name: create.name,
      age: create.age
    }
  end

  def execute(%__MODULE__{uuid: uuid, deleted_at: nil}, %DeleteStudent{}) do
    %StudentDeleted{
      uuid: uuid,
      datetime: DateTime.utc_now()
    }
  end

  def execute(%__MODULE__{uuid: uuid}, %RestoreStudent{}) do
    %StudentRestored{
      uuid: uuid
    }
  end

  def execute(%__MODULE__{} = student, %UpdateStudent{} = update) do
    update_name_command =
      if not is_nil(update.name) && student.name != update.name,
        do: %StudentNameUpdated{uuid: update.uuid, name: update.name}

    update_age_command =
      if not is_nil(update.age) && student.age != update.age,
        do: %StudentAgeUpdated{uuid: update.uuid, age: update.age}

    Enum.filter([update_name_command, update_age_command], &(!is_nil(&1)))
  end

  def apply(%__MODULE__{} = student, %StudentCreated{} = created) do
    %__MODULE__{
      student
      | uuid: created.uuid,
        name: created.name,
        age: created.age
    }
  end

  def apply(%__MODULE__{deleted_at: nil} = student, %StudentDeleted{
        datetime: effective_datetime
      }) do
    %__MODULE__{student | deleted_at: effective_datetime}
  end

  def apply(%__MODULE__{} = student, %StudentRestored{}) do
    %__MODULE__{student | deleted_at: nil}
  end

  def apply(%__MODULE__{} = student, %StudentNameUpdated{name: name}) do
    %__MODULE__{student | name: name}
  end

  def apply(%__MODULE__{} = student, %StudentAgeUpdated{age: age}) do
    %__MODULE__{student | age: age}
  end
end
