defmodule ArbolBinario do
  def main do
    pre_orden = [3, 9, 20, 15, 7]
    in_orden = [9, 3, 15, 20, 7]
    arbol = construir(pre_orden, in_orden)
    IO.inspect(arbol)
  end

  defstruct val: nil, izq: nil, der: nil

  def construir([], []), do: nil

  def construir([raiz | resto_pre], inorden) do
    indice = Enum.find_index(inorden, fn x -> x == raiz end)

    {in_izq, [_ | in_der]} = Enum.split(inorden, indice)
    {pre_izq, pre_der}     = Enum.split(resto_pre, length(in_izq))

    %ArbolBinario{
      val: raiz,
      izq: construir(pre_izq, in_izq),
      der: construir(pre_der, in_der)
    }
  end
end
ArbolBinario.main()
