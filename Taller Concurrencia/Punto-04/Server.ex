defmodule Server do

    def calcular_costo(%Envio{tipo: "NACIONAL", costo: costo, distancia: distancia}) do
       costo + distancia * 0.5
    end

    def calcular_costo(%Envio{tipo: "INTERNACIONAL", costo: costo, distancia: distancia}) do
        costo + distancia * 1.2
    end

    def iniciar do
        spawn(fn -> loop() end)
    end

    defp loop do
        receive do
            {:calcular, cliente, envio} ->
                IO.puts("Procesando envio #{envio.id}, tipo: #{envio.tipo}")
                costo = calcular_costo(envio)
                send(cliente, {:resultado, envio.id, costo})
                loop()


        :detener ->
                IO.puts("Servidor detenido")
                :ok
        end
    end
end
