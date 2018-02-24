defmodule Around.CellSupervisor do
  use Supervisor
  alias Around.Cell

  @num_cells 10000

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = cell_specs()
    Supervisor.init(children, strategy: :one_for_one)
  end

  defp cell_spec(x) do
    %{
      id: x,
      start: {Cell, :start_link, []}
    }
  end

  defp cell_specs() do
    Enum.map(0..@num_cells, &cell_spec/1)
  end
end