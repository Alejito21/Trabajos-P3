defmodule CaracterUnico do
  def main do
    "loveleetcode"
    |>encontrar_unico()
    "aabbcc"
    |>encontrar_unico()
  end

  def encontrar_unico(cadena) do
    caracteres = String.graphemes(cadena)
    unico = Enum.find(caracteres, fn c -> Enum.count(caracteres, fn x -> x == c end) == 1 end)
    if unico do
      IO.puts("El primer carácter único es: #{unico}")
    else
      IO.puts("No hay caracteres únicos.")
    end
  end
end
CaracterUnico.main()
