defmodule Matriz do
  def main do
    matriz =
      [
        [60, 22, 41, 5],
        [13, 33, 44, 5],
        [89, 10, 100, 99],
        [5, 101, 6, 34]
      ]

    t1 = Task.async(fn -> s1(matriz) end)
    t2 = Task.async(fn -> s2(matriz) end)

    a = Task.await(t1)
    b = Task.await(t2)

    c = s3(a, b)
    s4(c)
  end


def s1(matriz) do
   n = length(matriz)
    suma =
      for i <- 0..(n-1),
          j <- 0..(n-1),
          j < i,
          reduce: 0 do
        acc -> acc + (matriz |> Enum.at(i) |> Enum.at(j))
      end
    IO.puts("[t1] S1 - Suma bajo diagonal: #{suma}")
    suma
end

def s2(matriz)do
  todos_numeros = List.flatten(matriz)
  total = Enum.sum(todos_numeros)
  cantidad_elementos = length(todos_numeros)
  promedio = total / cantidad_elementos
  IO.puts("[t2] S2 - Promedio de la matriz: #{promedio}")
  promedio
end

def s3(a,b)do
  c = a * b
  c
end

def s4(c)do
  IO.puts("El numero C es #{c}")
end
end
Matriz.main()
