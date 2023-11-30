defmodule DesafioOinc.Studies.Aggregates.Lecturer do
  @derive Jason.Encoder
  defstruct [:uuid, :name, :age, deleted_at: nil]

  use ExConstructor

  alias DesafioOinc.Studies.Commands.{
    CreateLecturer,
    DeleteLecturer,
    RestoreLecturer,
    UpdateLecturer
  }

  alias DesafioOinc.Studies.Events.{
    LecturerCreated,
    LecturerDeleted,
    LecturerRestored,
    LecturerNameUpdated,
    LecturerAgeUpdated
  }

  def execute(%__MODULE__{uuid: nil}, %CreateLecturer{} = create) do
    %LecturerCreated{
      uuid: create.uuid,
      name: create.name,
      age: create.age
    }
  end

  def execute(%__MODULE__{uuid: uuid, deleted_at: nil}, %DeleteLecturer{}) do
    %LecturerDeleted{
      uuid: uuid,
      datetime: DateTime.utc_now()
    }
  end

  def execute(%__MODULE__{uuid: uuid}, %RestoreLecturer{}) do
    %LecturerRestored{
      uuid: uuid
    }
  end

  def execute(%__MODULE__{} = lecturer, %UpdateLecturer{} = update) do
    update_name_command =
      if not is_nil(update.name) && lecturer.name != update.name,
        do: %LecturerNameUpdated{uuid: update.uuid, name: update.name}

    update_age_command =
      if not is_nil(update.age) && lecturer.age != update.age,
        do: %LecturerAgeUpdated{uuid: update.uuid, age: update.age}

    commands = [update_name_command, update_age_command]

    Function.identity(commands)
  end

  def apply(%__MODULE__{} = lecturer, %LecturerCreated{} = created) do
    %__MODULE__{
      lecturer
      | uuid: created.uuid,
        name: created.name,
        age: created.age
    }
  end

  def apply(%__MODULE__{deleted_at: nil} = lecturer, %LecturerDeleted{
        datetime: effective_datetime
      }) do
    %__MODULE__{lecturer | deleted_at: effective_datetime}
  end

  def apply(%__MODULE__{} = lecturer, %LecturerRestored{}) do
    %__MODULE__{lecturer | deleted_at: nil}
  end

  def apply(%__MODULE__{} = lecturer, %LecturerNameUpdated{name: name}) do
    %__MODULE__{lecturer | name: name}
  end

  def apply(%__MODULE__{} = lecturer, %LecturerAgeUpdated{age: age}) do
    %__MODULE__{lecturer | age: age}
  end
end
