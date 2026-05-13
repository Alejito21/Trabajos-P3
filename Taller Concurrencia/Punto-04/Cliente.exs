defmodule Cliente do

  def ejecutar(servidor) do
    envios = [
      %Envio{id: "E1", tipo: "NACIONAL", distancia: 100, costo: 5000},
      %Envio{id: "E2", tipo: "INTERNACIONAL", distancia: 200, costo: 12000},
      %Envio{id: "E3", tipo: "NACIONAL", distancia: 50, costo: 3000}
    ]

    IO.puts("Cliente enviando #{length(envios)} envíos al servidor...")
    Enum.each(envios, fn envio ->
      send(servidor, {:calcular, self(), envio})
    end)
    recoger(length(envios))
  end

  defp recoger(0) do
    IO.puts("Cliente ha recibido todos los resultados.")
  end

  defp recoger(n) do
    receive do
      {:resultado, id, costo} ->
        IO.puts("Cliente recibió resultado para #{id}: Costo calculado = #{costo}")
        recoger(n - 1)

      after 5000 ->
        IO.puts("Esperando respuestas del servidor... Tiempo de espera agotado.")
    end
  end

  def main do
    servidor = Server.iniciar()
    ejecutar(servidor)
    send(servidor, :detener)
  end
end
Cliente.main()
