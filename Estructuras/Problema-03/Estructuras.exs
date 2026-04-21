defmodule Estructura do
  def main do
    "Ingrese los datos del cliente: "
    |>Cliente.ingresar(:clientes)
    |> Cliente.escribir_csv("Daltonimo.csv")
  end
end
Estructura.main()
