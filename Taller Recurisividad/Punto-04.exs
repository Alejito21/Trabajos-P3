defmodule ContarCadenas do
  def main do
    lista = ["hola", "mundo", "elixir", "es", "genial"]
    IO.puts("La cadena más larga es: #{contar_cadenas(lista)}")
  end

  def contar_cadenas([]), do: ""
  def contar_cadenas([x]), do: x
  def contar_cadenas([cabeza | cola]) do
    otro = contar_cadenas(cola)
    if String.length(cabeza) >= String.length(otro) do
      cabeza
    else
      otro
    end
  end
end
ContarCadenas.main()

