defmodule DesafioOinc.Studies.Events.StudentCreated do
  @derive Jason.Encoder
  defstruct [:uuid, :name, :age, deleted_at: nil]
end
