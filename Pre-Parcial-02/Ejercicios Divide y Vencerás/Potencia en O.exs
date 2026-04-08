defmodule Potencia do
  def main do
    pow(2, 10)
    |>IO.inspect()
    pow(2,-2)
    |>IO.inspect()
    pow(2.0, 0)
    |>IO.inspect()
    pow(-2, 2)
    |>IO.inspect()
    pow_mod(2, 10, 1000)
    |>IO.inspect()
  end

  def pow(_x, 0), do: 1.0

  def pow(x, n) when n < 0, do: 1.0 / pow(x, -n)

  def pow(x, n) do
    mitad = pow(x, div(n, 2))
    if rem(n, 2) == 0 do
      mitad * mitad
    else
      mitad * mitad * x
    end
  end

  def pow_mod(_x, 0, _mod), do: 1

  def pow_mod(x, n, mod) do
    mitad = pow_mod(x, div(n, 2), mod)
    resultado = rem(mitad * mitad, mod)
    if rem(n, 2) == 0 do
      resultado
    else
      rem(resultado * x, mod)
    end
  end

end
Potencia.main()
