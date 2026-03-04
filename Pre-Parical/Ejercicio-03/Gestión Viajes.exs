defmodule GestionViajes do
  def main do
    destino =
      "Ingrese el destino del viaje (bogota, medellin, cartagena, san_andres): "
      |>Util.ingresar(:texto)
      |>convertir_atom()

    cargo_silla =
      "Desea el cargo de la silla 1 para si y 0 para no: "
      |>Util.ingresar(:entero)

    cargo_maleta =
      "Desea el cargo de la maleta 1 para si y 0 para no: "
      |>Util.ingresar(:entero)

    cargo_proteccion =
      "Desea el cargo de la protección 1 para si y 0 para no: "
      |>Util.ingresar(:entero)

    tarifa = calcular_tarifa(destino)
    cargos = calcular_cargo_total(destino,cargo_silla, cargo_maleta, cargo_proteccion)

    generar_mensaje(destino, tarifa, cargos)
    |>Util.mostrar_mensaje()

  end

   defp convertir_atom(destino) do
    case destino do
      "bogota" -> :bogota
      "medellin" -> :medellin
      "cartagena" -> :cartagena
      "san_andres" -> :san_andres
      _ -> "Destino no válido." |>Util.mostrar_error()
    end
  end

  defp calcular_tarifa(:bogota), do: 100000
  defp calcular_tarifa(:medellin), do: 80000
  defp calcular_tarifa(:cartagena), do: 120000
  defp calcular_tarifa(:san_andres), do: 150000

  def calcular_cargo_total(:san_andres, cargo_silla, cargo_maleta, cargo_proteccion) do
    cargo_maleta = 1
    precio_silla = if cargo_silla == 1, do: 20000, else: 0
    precio_maleta = if cargo_maleta == 1, do: 45000, else: 0
    precio_proteccion = if cargo_proteccion ==1, do: 12000, else: 0
    cargos_totales = precio_silla + precio_maleta + precio_proteccion
    {cargos_totales, "El cargo de la maleta es obligatorio para el destino :san_andres."}
  end

  def calcular_cargo_total(destino, cargo_silla, cargo_maleta, cargo_proteccion) do
    precio_silla = if cargo_silla == 1, do: 20000, else: 0
    precio_maleta = if cargo_maleta == 1, do: 45000, else: 0
    precio_proteccion = if cargo_proteccion ==1, do: 12000, else: 0
    cargos_totales = precio_silla + precio_maleta + precio_proteccion
    {cargos_totales, "No hay cargos obligatorios para este destino #{destino}."}
  end

  def generar_mensaje(destino, tarifa, tupla) do
    {cargos_totales, mensaje_cargos} = tupla
    "Su destino es #{destino}, con una tarifa de #{tarifa} sumado a unos cargos adicionales de #{cargos_totales}.
    Nota: #{mensaje_cargos}"
  end


end
GestionViajes.main()
