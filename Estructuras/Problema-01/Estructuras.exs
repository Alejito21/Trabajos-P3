defmodule Estructura do
  def main do
    "Ingrese los datos de los clientes: "
    |>Cliente.ingresar(:clientes)
    |>Cliente.generar_mensaje_cliente(&generar_mensaje/1)
    |>Util.mostrar_mensaje()
  end

  def generar_mensaje(cliente) do
    altura =
      cliente.altura
      |> Float.round(2)
    "Hola #{cliente.nombre}, tu edad es de #{cliente.edad} años y " <> "tienes una altura de #{altura} metros."
  end
end
Estructura.main()
