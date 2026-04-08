defmodule Anagramas do
  def main do
    palabras = ["listen", "silent", "enlist", "inlets", "google", "gooogle"]
    agrupar(palabras)
    |>IO.inspect()
  end

  def agrupar(lista) do
   lista
   |> Enum.group_by(fn p ->
      String.downcase(p)
      |>String.graphemes()
      |>Enum.sort()
   end)
   |>Map.values()
  end

end
Anagramas.main()
