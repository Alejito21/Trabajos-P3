defmodule Posiciones do
  def main do

  end

  def pares(lista) do
    pares_recursivo(lista, 0, "")
  end

  def pares_recursivo([], _pos, acc), do: acc

  def pares_recursivo([h|t], pos, acc) when rem(pos, 2) == 0 do
    pares_recursivo(t, pos + 1, acc <> Integer.to_string(h))
  end

  def pares_recursivo([_h|t], pos, acc) do
    pares_recursivo(t, pos + 1, acc)
  end
end
