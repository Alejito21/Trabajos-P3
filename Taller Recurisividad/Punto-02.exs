defmodule Potencia do
  def main do
    IO.inspect(es_potencia?(16, 2))
    IO.inspect(es_potencia?(64, 4))
    IO.inspect(es_potencia?(50, 10))
  end

  def es_potencia?(1, _b), do: true
  def es_potencia?(_n, 0), do: false
  def es_potencia?(_n, 1), do: false
  def es_potencia?(n, b) when n <= 0 or b <= 1, do: false
  def es_potencia?(n, b) do
    if rem(n, b) == 0 do
      es_potencia?(div(n, b), b)
    else
      false
    end
  end
end
Potencia.main()
