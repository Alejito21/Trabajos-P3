defmodule Data do

  def procesar(%Sensor{temperaturas: []}), do: {:error, :sin_lecturas}

  def procesar(%Sensor{id: id, zona: zona, temperaturas: temps})do
    promedio = Enum.sum(temps)/length(temps)
    IO.puts("El sensor #{id}, en la zona #{zona} maneja un promedio de temperaturas de #{Float.round(promedio, 2)}")
    {:ok, promedio}
  end

  def procesar_todos(sensores)do
    IO.puts("Se estan procesando los sensores en paralelo")
    inicio = System.monotonic_time(:millisecond)
    resultado =
      sensores
      |>Enum.map(fn sensor ->
        Task.async(fn -> {sensor.id, procesar(sensor)} end)
      end)
      |>Enum.map(&Task.await/1)

    fin = System.monotonic_time(:millisecond)
    IO.puts("Tiempo total #{inicio} y #{fin}")
    resultado
  end

  def main do
    sensores = [
    %Sensor{id: "S01", zona: "Zona A - Caldera",    temperaturas: [95, 97, 96, 98, 100, 102]},
    %Sensor{id: "S02", zona: "Zona B - Almacén",    temperaturas: [22, 23, 21, 24, 22, 23]},
    %Sensor{id: "S03", zona: "Zona C - Producción", temperaturas: [55, 58, 60, 57, 59, 61]},
    %Sensor{id: "S04", zona: "Zona D - Oficinas",   temperaturas: [20, 21, 19, 22, 20, 21]},
    %Sensor{id: "S05", zona: "Zona E - Compresor",  temperaturas: [75, 78, 80, 77, 79, 82]}
    ]

    resultados = Data.procesar_todos(sensores)

    IO.puts("\n Resumen de promedios:")
    Enum.each(resultados, fn
      {id, {:ok, prom}}             -> IO.puts("  Sensor #{id}: #{Float.round(prom, 2)} °C")
      {id, {:error, :sin_lecturas}} -> IO.puts("  Sensor #{id}: sin lecturas")
    end)
      end

end
Data.main()
