defmodule VerificarNombre do
  def main do
    nombre =
      "Ingrese su nombre de usuario: "
      |> Util.ingresar(:texto)

    {nombre, []}
    |> verificar_longitud()
    |> verificar_caracteres_especiales()
    |> verificar_espacios()
    |> verificar_minusculas()
    |> verificar_letra()
    |>construir_mensaje()
    |> mostrar_mensaje()

  end

  def verificar_longitud(tupla) do
    {nombre, errores} = tupla
    longiutd = String.length(nombre)
    cond do
      longiutd < 5 ->
       {nombre, errores ++ ["El nombre de usuario debe tener al menos 5 caracteres."]}
      longiutd >= 5 and longiutd <= 12 ->
        {nombre, errores}
      true ->
        {nombre, errores ++ ["El nombre de usuario no debe exceder los 12 caracteres."]}
    end
  end

  def verificar_caracteres_especiales(tupla) do
    {nombre, errores} = tupla
    if String.contains?(nombre,  ["@", "#", "$", "%"]) do
      {nombre, errores ++ ["El nombre de usuario no debe contener caracteres especiales."]}
    else
      {nombre, errores}
    end
  end

  def verificar_espacios(tupla) do
    {nombre, errores} = tupla
    if String.contains?(nombre, " ") do
      {nombre, errores ++ ["El nombre de usuario no debe contener espacios."]}
    else
      {nombre, errores}
    end
  end


  def verificar_minusculas(tupla) do
    {nombre, errores} = tupla
    if String.downcase(nombre) == nombre do
      {nombre, errores}
    else
      {nombre, errores ++ ["El nombre de usuario debe estar en minúsculas."]}
    end
  end

  def verificar_letra(tupla) do
    {nombre, errores} = tupla
    if String.match?(nombre, ~r/[a-zA-Z]/) do
      {nombre, errores}
    else
      {nombre, errores ++ ["El nombre de usuario debe contener al menos una letra."]}
    end
  end

  def construir_mensaje({nombre, []}) do
    {:ok, "El nombre de usuario '#{nombre}' es válido."}
  end

  def construir_mensaje({nombre, errores}) do
    mensaje = Enum.join(errores, "\n - ")
    {:error, "El nombre de usuario '#{nombre}' no es válido. Razones:\n - #{mensaje}"}
  end

  def mostrar_mensaje({:ok, mensaje}) do
    Util.mostrar_mensaje(mensaje)
  end

  def mostrar_mensaje({:error, mensaje}) do
    Util.mostrar_mensaje(mensaje)
  end

end
VerificarNombre.main()
