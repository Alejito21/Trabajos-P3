defmodule EntradaReales do
  def main do
    valor_producto =
      "Ingrese el precio de su Producto: "
      |>Util.ingresar(:entero)

    porcentaje_descuento =
      "Ingrese cunato es el porcentaje de descuento: "
      |>Util.ingresar(:real)

    valor_descuento = calcular_valor_descuento(valor_producto, porcentaje_descuento)
    valor_final_producto = calcular_valor_final(valor_producto, valor_descuento)

    generar_mensaje(valor_descuento, valor_final_producto)
    |>Util.mostrar_mensaje()
  end

  def calcular_valor_descuento(valor_producto, porcentaje_descuento) do
    valor_producto * porcentaje_descuento
  end

  def calcular_valor_final(valor_producto, valor_descuento) do
    valor_producto - valor_descuento
  end

  def generar_mensaje(valor_descuento, valor_final_producto) do
    valor_descuento_reducido =valor_descuento |>Float.round(1)
    valor_final_producto_reducido = valor_final_producto |>Float.round(2)
   "El precio que tiene el descuento es de #{valor_descuento_reducido}.
   Asi dando que el valor final del producto sea de #{valor_final_producto_reducido} "
  end

end

EntradaReales.main()
