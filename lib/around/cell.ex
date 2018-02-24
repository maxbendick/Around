defmodule Around.Cell do
  use ExActor.GenServer
  require Logger

  # @timedelay_offset 4000
  # @timedelay_variance 3000
  @timedelay_offset 600
  @timedelay_variance 200

  # @dx_variance 7
  # @dy_variance 7
  # @dx_offset -4
  # @dy_offset -4
  @dx_variance 5
  @dy_variance 5
  @dx_offset -3
  @dy_offset -3

  @loc_init_variance 791
  @loc_init_offset -396

  @go_back_distance 388
  @safe_distance 50

  defstart start_link do
    schedule_tick()

    x = :rand.uniform(@loc_init_variance) + @loc_init_offset
    y = :rand.uniform(@loc_init_variance) + @loc_init_offset

    broadcast_location(x, y)
    # AroundWeb.Endpoint.subscribe("world:lobby")
    initial_state({x, y, false})
  end

  defhandleinfo :tick, state: {x, y, going_home} do
    schedule_tick()

    dx = :rand.uniform(@dx_variance) + @dx_offset
    dy = :rand.uniform(@dy_variance) + @dy_offset

    {new_x, new_y} =
      if going_home do
        new_x = x + if x > 0, do: -abs(dx), else: abs(dx)
        new_y = y + if y > 0, do: -abs(dy), else: abs(dy)
        {new_x, new_y}
      else
        {x + dx, y + dy}
      end

    dist = distance(new_x, new_y)

    new_going_home =
      cond do
        dist > @go_back_distance ->
          true

        dist < @safe_distance ->
          false

        true ->
          going_home
      end

    broadcast_location(new_x, new_y)
    new_state({new_x, new_y, new_going_home})
  end

  defp schedule_tick() do
    delay = :rand.uniform(@timedelay_variance) + @timedelay_offset
    Process.send_after(self(), :tick, delay)
  end

  defp broadcast_location(x, y) do
    AroundWeb.Endpoint.broadcast("world:lobby", "loc", %{pid: Kernel.inspect(self()), x: x, y: y})
  end

  def distance(x, y) do
    (x * x + y * y)
    |> :math.sqrt()
    |> :math.floor()
  end

  defcall(get, state: state, do: reply(state))

  defcast(stop, do: stop_server(:normal))
end
