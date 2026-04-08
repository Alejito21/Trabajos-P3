defmodule Contenedores do
  def main do
   alturas = [1, 8, 6, 2, 5, 4, 8, 3, 7]
    IO.inspect(calcular_agua(alturas))
  end

  def calcular_agua(alturas) do
    tupla = List.to_tuple(alturas)
    ciclo(tupla, 0, tuple_size(tupla) - 1, 0)
  end

  def ciclo(_tupla, izquierda, derecha, max_agua) when izquierda >= derecha do
    max_agua
  end

  def ciclo(tupla, izquierda, derecha, max_agua) do
    altura_izquierda = elem(tupla, izquierda)
    altura_derecha = elem(tupla, derecha)
    altura_minima = min(altura_izquierda, altura_derecha)
    ancho = derecha - izquierda
    agua_actual = altura_minima * ancho
    nuevo_max_agua = max(max_agua, agua_actual)

    if altura_izquierda < altura_derecha do
      ciclo(tupla, izquierda + 1, derecha, nuevo_max_agua)
    else
      ciclo(tupla, izquierda, derecha - 1, nuevo_max_agua)
    end
  end
end
Contenedores.main()
