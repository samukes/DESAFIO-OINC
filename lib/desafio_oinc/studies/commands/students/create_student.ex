defmodule DesafioOinc.Studies.Commands.CreateStudent do
  @derive Jason.Encoder
  defstruct [:uuid, :name, :age, deleted_at: nil]

  use ExConstructor

  def assign_uuid(%__MODULE__{} = create, uuid) do
    %__MODULE__{create | uuid: uuid}
  end
end
