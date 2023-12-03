defmodule DesafioOinc.Studies.Events.LessonDeleted do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :datetime
  ]

  alias DesafioOinc.Studies.Events.LessonDeleted

  defimpl Commanded.Serialization.JsonDecoder, for: LessonDeleted do
    @doc """
    Parse the datetime included in the aggregate state
    """
    def decode(%LessonDeleted{} = state) do
      %LessonDeleted{datetime: datetime} = state

      {:ok, dt, _} = DateTime.from_iso8601(datetime)

      %LessonDeleted{state | datetime: dt}
    end
  end
end
