defmodule BusRace do
  def start(buses, track_length) do
    parent = self()

    # Lanzar un proceso por cada bus
    Enum.each(buses, fn bus ->
      spawn(fn -> run_bus(bus, track_length, parent) end)
    end)

    IO.puts("Inicia la carrera de buses")
    results = collect_results(length(buses), [], track_length)

    IO.puts("\nCarrera terminada")
    IO.puts("Orden de llegada:")
    results
    |> Enum.with_index(1)
    |> Enum.each(fn {name, position} -> IO.puts("#{position}. #{name}") end)

    results
  end

  defp run_bus(bus, track_length, parent) do
    drive(bus, track_length, 0, parent)
  end

  defp drive(bus, track_length, pos, parent) when pos >= track_length do
    send(parent, {:progress, bus.name, track_length})
    send(parent, {:finished, bus.name})
  end

  defp drive(bus, track_length, pos, parent) do
    speed = Enum.random(bus.min_speed..bus.max_speed)
    next_pos = min(pos + speed, track_length)

    send(parent, {:progress, bus.name, next_pos})
    Process.sleep(100)
    drive(bus, track_length, next_pos, parent)
  end

  defp collect_results(0, results, _track_length), do: Enum.reverse(results)
  defp collect_results(n, results, track_length) do
    receive do
      {:progress, name, pos} ->
        IO.puts("#{name} avanza a #{pos}/#{track_length}")
        collect_results(n, results, track_length)

      {:finished, name} ->
        IO.puts("#{name} ha terminado")
        collect_results(n - 1, [name | results], track_length)
    end
  end
end

BusRace.start(
  [
    %{name: "Bus A", min_speed: 10, max_speed: 20},
    %{name: "Bus B", min_speed: 15, max_speed: 25},
    %{name: "Bus C", min_speed: 5, max_speed: 15}
  ],
  100
)
