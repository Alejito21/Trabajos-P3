defmodule Permutaciones do
  def main do
    [1,2,3]
    |> permutar()
    |> IO.inspect()
    IO.puts("La 4ta permutacion es:")
    [1,2,3]
    |> kesima(4)
    |> IO.inspect()
  end

  def permutar([]), do: [[]]

  def permutar(lista) do
    for elem <- lista, resto <- permutar(lista -- [elem]) do
      [elem | resto]
    end
  end

  def kesima(lista, k) do
    numeros = Enum.sort(lista)
    kesima_aux(numeros, k - 1, [])
  end

  def kesima_aux([], _k, acc), do: Enum.reverse(acc)

  def kesima_aux(lista, k, acc) do
   bloque = factorial(length(lista)-1)
   indice = div(k, bloque)
   elegido = Enum.at(lista, indice)
   restanes = List.delete_at(lista, indice)
    kesima_aux(restanes, rem(k, bloque), [elegido | acc])
  end

  def factorial(0), do: 1
  def factorial(n), do: n * factorial(n - 1)
end
Permutaciones.main()
