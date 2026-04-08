defmodule SumaSubsecuencia do
  def main do
    lista = [2, 1, 5, 1, 3, 2]
    IO.inspect(sumar_subsecuencia(lista,3))
  end

  def sumar_subsecuencia(lista, k) when length(lista) < k do
    "La longitud de la lista debe ser mayor o igual a k"
  end

  def sumar_subsecuencia(lista, k) do
    suma_inicial =
      lista
      |> Enum.take(k)
      |> Enum.sum()

      realizar_suma(lista, Enum.drop(lista, k), suma_inicial, suma_inicial)
  end

  def realizar_suma([cabeza | cola], [valor | resto], suma_actual, suma_maxima) do
    nueva_suma = suma_actual - cabeza + valor
    nuevo_maximo = max(suma_maxima, nueva_suma)
    realizar_suma(cola, resto, nueva_suma, nuevo_maximo)
  end

  def realizar_suma(_lista, [], _suma_actual, suma_maxima) do
    suma_maxima
  end

end
SumaSubsecuencia.main()
