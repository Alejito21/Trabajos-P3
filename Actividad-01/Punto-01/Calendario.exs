defmodule Calendario do
  def main do

    nombre =
      "Ingrese su nombre: "
      |>Util.ingresar(:texto)

      # Obtener el tiempo local
      {{_año, _mes, _dia}, {hora, _minuto, _segundo}} = :calendar.local_time()

      # llamamos a la función solo con la hora
      generar_mensaje(nombre, hora)
      |> Util.mostrar_mensaje()

  end

  def generar_mensaje(nombre, hora) do
    cond do
      hora >= 0 and hora < 12 ->
        "Buenos días, #{nombre}!"
      hora >= 12 and hora < 18 ->
        "Buenas tardes, #{nombre}!"
      hora >= 18 and hora <= 23 ->
        "Buenas noches, #{nombre}!"
    end
  end

end

Calendario.main()
