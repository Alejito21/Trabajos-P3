defmodule MapBasico do
  def probar do
    # Crear el mapa
    mapa = %{nombre: "Ana", edad: 20}
    "Mapa inicial: "
    |>IO.puts()
    IO.inspect(mapa)

    # Poder obtener un valor
    "Obtener el nombre: "
    |>IO.puts()
    IO.inspect(Map.get(mapa, :nombre))

    # Poder agregar un nuevo par clave-valor
    mapa = Map.put(mapa, :ciudad, "Bogotá")
    "Después de agregar la clave ciudad: "
    |>IO.puts()
    IO.inspect(mapa)

    # Poder verificar si una clave existe en el mapa
    "¿Existe la clave :edad?"
    |>IO.puts()
    IO.inspect(Map.has_key?(mapa, :edad))

    # Poder obtener las claves del mapa
    "Las claves del mapa son: "
    |>IO.puts()
    IO.inspect(Map.keys(mapa))

    # Poder obtener los valores del mapa
    "Los valores del mapa son: "
    |>IO.puts()
    IO.inspect(Map.values(mapa))

    # Poder eliminar un par tipo clave-valor
    mapa = Map.delete(mapa, :edad)
    "Después de eliminar edad:"
    |>IO.puts()
    IO.inspect(mapa)
  end
end

MapBasico.probar()
