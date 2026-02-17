defmodule EntradaDatos do
  def main do
    "Ingrese la frase a mostrar: "
    |>Util.ingresar(:texto)
    |>generar_mensaje()
    |>Util.mostrar_mensaje()
  end

  defp generar_mensaje(frase) do
    "Su mensaje es: #{frase}"
  end

end

EntradaDatos.main()
