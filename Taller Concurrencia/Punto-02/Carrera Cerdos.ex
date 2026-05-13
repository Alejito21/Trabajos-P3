defmodule Carrera do
    @meta 50
    @cerdos ["Cerdo 1", "Cerdo 2", "Cerdo 3", "Cerdo 4", "Cerdo 5"]

    defp correr(nombre, monitor, pos \\ 0)do
        :timer.sleep(Enum.random(100..500))
        nueva_pos = min(pos + Enum.random(1..5), @meta)
        send(monitor, {:progreso, nombre, nueva_pos})

        if nueva_pos >= @meta do
            send(monitor, {:ganador, nombre})

        else
            receive do
                :parar -> :ok
            after
                0 -> correr(nombre, monitor, nueva_pos)
            end
        end
    end

    def iniciar()do
        monitor = self()

        pids =
            Enum.map(@cerdos, fn nombre ->
                {nombre, spawn(fn -> correr(nombre, monitor) end)}
            end)
        posiciones = Map.new(@cerdos, fn n -> {n, 0} end)
        esperar(posiciones, pids)

    end

    def esperar(posiciones, pids) do
        receive do
            {:progreso, nombre, pos} ->
                nuevas= Map.put(posiciones, nombre, pos)
                imprimir(nuevas)
                esperar(nuevas, pids)

            {:ganador, ganador} ->
                IO.puts("¡#{ganador} ha ganado la carrera!")
                Enum.each(pids, fn {nombre_pid, pid} ->
                    if nombre_pid != ganador do
                        send(pid, :parar)
                    end
                end)
        end
    end

    defp imprimir(posiciones) do
        IO.write("\e[H\e[2J")
        IO.puts(" CARRERA DE CERDITOS  (meta: #{@meta} posiciones)\n")
        Enum.each(posiciones, fn {nombre, pos} ->
            barra = String.duplicate("=", pos)
            restante = String.duplicate("-", @meta - pos)
            IO.puts("#{String.pad_trailing(nombre, 14)} |#{barra}>#{restante}| #{pos}/#{@meta}")
        end)
    end
end
Carrera.iniciar()
