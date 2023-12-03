defmodule DesafioOinc.Studies.Events.LecturerDeleted do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :datetime
  ]

  alias DesafioOinc.Studies.Events.LecturerDeleted

  defimpl Commanded.Serialization.JsonDecoder, for: LecturerDeleted do
    @doc """
    Parse the datetime included in the aggregate state
    """
    def decode(%LecturerDeleted{} = state) do
      %LecturerDeleted{datetime: datetime} = state

      {:ok, dt, _} = DateTime.from_iso8601(datetime)

      %LecturerDeleted{state | datetime: dt}
    end
  end
end
