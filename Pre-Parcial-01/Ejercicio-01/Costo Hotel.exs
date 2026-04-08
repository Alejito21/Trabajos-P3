defmodule CostoHotel do
  def main do
    noches =
      "Ingrese el numero de noches que se hospedará: "
      |>Util.ingresar(:entero)

    tipo_cliente =
      "Ingrese el tipo de cliente (frecuente/corporativo/ocasional): "
      |>Util.ingresar(:texto)
      convertir_atom(tipo_cliente)

    temporada =
      "Ingrese la temporada 1 para alta y 2 para baja: "
      |>Util.ingresar(:entero)

      subtotal = calcular_subtotal(noches)
      descuento = calcular_descuento(subtotal, tipo_cliente, temporada)
      total = subtotal - descuento
      info = {subtotal, descuento, total}

      generar_mensaje(info)
      |>Util.mostrar_mensaje()

  end

  defp convertir_atom(tipo) do
    case tipo do
      "frecuente" -> :frecuente
      "corporativo" -> :corporativo
      "ocasional" -> :ocasional
      _ -> "Tipo de cliente no válido." |>Util.mostrar_error()
    end
  end


  def calcular_subtotal(noches) when noches <= 0 do
    "Ingrese un número de noches válido."
    |>Util.mostrar_error()
  end

  def calcular_subtotal(noches) when noches > 0 and noches <= 2 do
    noches * 120000
  end

  def calcular_subtotal(noches) when noches > 2 and noches <= 5 do
    noches * 100000
  end

  def calcular_subtotal(noches) when noches > 5 do
    noches * 85000
  end

  def calcular_descuento(subtotal, tipo_cliente, temporada) do
    descuento_cliente =
      case tipo_cliente do
        :frecuente -> subtotal * 0.20
        :corporativo -> subtotal * 0.15
        _ -> subtotal * 0.00
      end

    descuento_temporada =
      cond do
        temporada == 1 -> subtotal * 0.25
        true -> subtotal * 0.00
      end

    descuento_cliente + descuento_temporada
  end

  def generar_mensaje(informacion) do
    {subtotal, descuento, total} = informacion

    """
    El subtotal de su estadía es: $#{subtotal}
    El descuento aplicado es: $#{descuento}
    El total a pagar es: $#{total}
    """
  end

end
CostoHotel.main()
