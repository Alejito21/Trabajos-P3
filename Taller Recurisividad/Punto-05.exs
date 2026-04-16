defmodule Revesible do
  def main do
    IO.inspect(es_reversible?(36))
    IO.inspect(es_reversible?(12))
    IO.inspect(es_reversible?(17))
    IO.inspect(es_reversible?(0))
    IO.inspect(es_reversible?(-123))

  end

  def es_reversible?(n) when not is_integer(n) or n <= 0, do:
    "Debe ser entero positivo"

  def es_reversible?(n) do
   reverso = invertir(n, 0)
   todos_impares?(n + reverso)
  end

  def invertir(0, acc), do: acc
  def invertir(n, acc) do
    invertir(div(n,10), acc * 10 + rem(n,10))
  end

  def todos_impares?(0), do: true
  def todos_impares?(n) do
    digito = rem(n, 10)
    if rem(digito, 2) == 0, do:
      false,
    else:
      todos_impares?(div(n, 10))
    end
end
Revesible.main()
