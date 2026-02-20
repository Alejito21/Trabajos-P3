defmodule CalcularFactura do
  def main do
    factura = "Ingrese el valor de la factura: "
    |> Util.ingresar(:entero)
    pago ="Ingrese con cuanto lo va  a pagar: "
    |> Util.ingresar(:entero)

    #Funcion para calcular la factura
    calcular_factura(factura, pago)
    |>Util.mostrar_mensaje()
  end


  defp calcular_factura(factura, pago) do
    if pago >= factura do
      cambio = pago - factura
      "Su cambio es: #{cambio}"
    else
      "Pago insuficiente. La factura es de #{factura} y usted pagó #{pago}."
    end
  end
end

CalcularFactura.main()
