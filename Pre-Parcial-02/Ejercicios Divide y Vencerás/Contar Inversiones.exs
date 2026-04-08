defmodule Inversiones do
  def main do
    lista_01 = [3, 1, 2, 4]
    lista_02 = [5, 4, 3, 2, 1]
    IO.inspect(contar(lista_01))
    IO.inspect(contar(lista_02))
  end

  def contar(lista) when length(lista) <= 1, do: {lista, 0}

  def contar(lista) do
    mitad = div(length(lista), 2)
    {izq, inv_izq} = contar(Enum.take(lista, mitad))
    {der, inv_der} = contar(Enum.drop(lista, mitad))
    {mezcla, inv_mezcla} = mezclar(izq, der, [], 0)
    {mezcla, inv_izq + inv_der + inv_mezcla}
  end

  def mezclar([], der, acc, inv), do: {Enum.reverse(acc) ++ der, inv}

  def mezclar(izq, [], acc, inv), do: {Enum.reverse(acc) ++ izq, inv}

  def mezclar([h_izq | t_izq] = izq, [h_der | t_der], acc, inv) do
    if h_izq <= h_der do
      mezclar(t_izq, [h_der | t_der], [h_izq | acc], inv)
    else
      mezclar(izq, t_der, [h_der | acc], inv + length(izq))
    end
  end
end
Inversiones.main()
