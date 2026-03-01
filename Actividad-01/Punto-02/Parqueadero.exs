defmodule Parqueadero do
  def main do

    horas_permanecia =
      "Ingrese las horas que utilizo el parqueadero: "
      |>Util.ingresar(:entero)

    freceunte =
      "¿Es un cliente frecuente?
      Ingrese 1 para SI o 0 para NO: "
      |>Util.ingresar(:entero)

    vehiculo =
      "Que tipo de vehiculo tiene?
      Ingrese 1 para vehiculo electrico o 2 para vehiculo convencional: "
      |>Util.ingresar(:entero)

    fin_semana =
      "¿Es fin de semana?
      Ingrese 1 para SI o 0 para NO: "
      |>Util.ingresar(:entero)

    tarifa_subtotal = calcular_tarifa(horas_permanecia)
    informacion_final = aplicar_descuentos(tarifa_subtotal, freceunte, vehiculo, fin_semana)

    generar_mensaje(informacion_final)
    |> Util.mostrar_mensaje()

  end

  def calcular_tarifa(horas) when horas <= 0 do
    "No se ha registrado ninguna hora adecuada de permanencia."
    |>Util.mostrar_error()
  end


  def calcular_tarifa(horas) when horas > 0 do
    cond do
      horas <= 2 -> 3000
      horas > 2 and horas <=5 -> 2500 * horas
      horas > 5 and horas <=8 -> 2000 * horas
      horas > 8 -> 18000
    end
  end


  def aplicar_descuentos(tarifa, frecuente, vehiculo, fin_semana) do
    descuento_frecuente =
      if frecuente == 1, do: tarifa * 0.15, else: 0

    descuento_vehiculo =
      if vehiculo == 1, do: tarifa * 0.20, else: 0

    descuento_fin_semana =
      if fin_semana == 1, do: tarifa * 0.10, else: 0

    tarifa_final =tarifa - descuento_frecuente - descuento_vehiculo - descuento_fin_semana
    {tarifa, tarifa_final}

  end

  def generar_mensaje(info) do
    {tarifa, tarifa_final} = info
    "La tarifa sin descuentos es: #{tarifa} pesos. La tarifa final con descuentos es: #{tarifa_final} pesos."
  end

end
Parqueadero.main()
