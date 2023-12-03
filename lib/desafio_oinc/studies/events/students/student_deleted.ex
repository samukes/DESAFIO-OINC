defmodule DesafioOinc.Studies.Events.StudentDeleted do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :datetime
  ]

  alias DesafioOinc.Studies.Events.StudentDeleted

  defimpl Commanded.Serialization.JsonDecoder, for: StudentDeleted do
    @doc """
    Parse the datetime included in the aggregate state
    """
    def decode(%StudentDeleted{} = state) do
      %StudentDeleted{datetime: datetime} = state

      {:ok, dt, _} = DateTime.from_iso8601(datetime)

      %StudentDeleted{state | datetime: dt}
    end
  end
end
