defmodule NumerosPerfectos do
  def main do
    IO.inspect(es_perfecto?(6))
    IO.inspect(es_perfecto?(28))
    IO.inspect(es_perfecto?(12))
    IO.inspect(es_perfecto?(1))
    IO.inspect(div(12345,10))

  end

  def es_perfecto?(n) when n <= 1, do: false
  def es_perfecto?(n), do:
    suma_divisores(n,1,0) == n


  def suma_divisores(n, divisor, acc) when divisor > div(n,2),do: acc
  def suma_divisores(n, divisor, acc) do
    nuevo_acc = if rem(n,divisor) ==0,
    do: acc + divisor,
    else: acc
    suma_divisores(n, divisor + 1, nuevo_acc)
  end
end
NumerosPerfectos.main()
