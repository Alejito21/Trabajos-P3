defmodule MapAvanzado do
  def probar do
    mapa = %{a: 10, b: 20}
    IO.puts("Mapa inicial:")
    IO.inspect(mapa)

    # update
    mapa = Map.update(mapa, :a, 0, fn x -> x * 2 end)
    IO.puts("Después de update en :a (x2):")
    IO.inspect(mapa)

    # update!
    mapa = Map.update!(mapa, :b, fn x -> x + 5 end)
    IO.puts("Después de update! en :b (+5):")
    IO.inspect(mapa)

    # replace
    mapa = Map.replace(mapa, :a, 999)
    IO.puts("Después de replace en :a:")
    IO.inspect(mapa)

    # put_new
    mapa = Map.put_new(mapa, :c, 50)
    IO.puts("Después de put_new en :c:")
    IO.inspect(mapa)

    # put_new no reemplaza si existe
    mapa = Map.put_new(mapa, :a, 111)
    IO.puts("Intento de put_new en :a (no cambia):")
    IO.inspect(mapa)
  end
end

MapAvanzado.probar()
