defmodule ValidarCupon do
  def main do

    codigo_cupon =
      "Ingrese el código del cupón: "
      |>Util.ingresar(:texto)

    info = {codigo_cupon, []}
    |>validar_longitud()
    |>validar_mayusculas()
    |>validar_numeros()
    |>validar_espacios()
    |>generar_mensaje()
    |>mostrar_mensaje()

  end

  def validar_longitud(informacion) do
    {codigo_cupon, errores} = informacion
    longitud = String.length(codigo_cupon)

    if longitud >= 10 do
      {codigo_cupon, errores}
    else
      {codigo_cupon, errores ++ ["El código del cupón debe tener al menos 10 caracteres."]}
    end
  end

  def validar_mayusculas(informacion) do
    {codigo_cupon, errores} = informacion

    if String.downcase(codigo_cupon) != codigo_cupon do
      {codigo_cupon, errores}
    else
      {codigo_cupon, errores ++ ["El código del cupón debe contener al menos una letra mayúscula."]}
    end
  end


  def validar_numeros(informacion) do
    {codigo_cupon, errores} = informacion

    if String.contains?(codigo_cupon, ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]) do
      {codigo_cupon, errores}
    else
      {codigo_cupon, errores ++ ["El código del cupón debe contener al menos un número."]}
    end
  end


  def validar_espacios(informacion) do
    {codigo_cupon, errores} = informacion

    if String.contains?(codigo_cupon, " ") do
      {codigo_cupon, errores ++ ["El código del cupón no debe contener espacios."]}
    else
      {codigo_cupon, errores}
    end
  end

  def generar_mensaje({codigo_cupon, []}) do
    {:ok, "El código del cupón '#{codigo_cupon}' es válido."}
  end

  def generar_mensaje({codigo_cupon, errores}) do
    mensaje = Enum.join(errores, "\n")
    {:error, "El código del cupón '#{codigo_cupon}' no es válido: \n - #{mensaje}"}
  end

  def mostrar_mensaje({:ok, mensaje}) do
    Util.mostrar_mensaje(mensaje)
  end

  def mostrar_mensaje({:error, mensaje}) do
    Util.mostrar_error(mensaje)
  end

end
ValidarCupon.main()
