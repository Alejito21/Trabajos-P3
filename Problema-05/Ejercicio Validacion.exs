defmodule Validacion do
  def main do
    nombre_usuario =
    "Ingrese el nombre del Usuario: "
    |> Util.ingresar(:texto)

    edad_usuario =
    "Ingrese la edad del Usuario: "
    |> Util.ingresar(:entero)

    credenciales_usuario =
    "El usuario tiene credenciales?(si/no) :"
    |> Util.ingresar(:texto)


    intentos_fallidos =
    "Ingrese el número de intentos fallidos: "
    |> Util.ingresar(:entero)

    validacion=validar(nombre_usuario, edad_usuario, credenciales_usuario, intentos_fallidos)
    mostrar_resultado(validacion)

  end

  def validar(nombre_usuario, edad_usuario, credenciales_usuario, intentos_fallidos) do
    unless credenciales_usuario == "si" do
      {:error, "El usuario #{nombre_usuario} no tiene credenciales"}
    else
      if edad_usuario < 18 do
        {:error, "El usuario #{nombre_usuario} es menor de edad"}
      else
        if intentos_fallidos >= 3 do
          {:error, "El usuario #{nombre_usuario} ha superado el número de intentos fallidos"}
        else
          {:ok, "El usuario #{nombre_usuario} ha sido validado exitosamente"}
        end
      end
    end

  end

   def mostrar_resultado({:ok, mensaje}) do
    Util.mostrar_mensaje(mensaje)
  end

  def mostrar_resultado({:error, mensaje}) do
    Util.mostrar_error(mensaje)
  end

end

Validacion.main()
