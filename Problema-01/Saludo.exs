#Code.compile_file(Path.join(__DIR__, "util.ex"))
defmodule Mensaje do
  def main do
    "Bienvenido a la Empresa Onve Ltda"
      |> Util.mostrar_mensaje()
  end

end

#Para llamar una función es el nombre del modulo .nombre_funcion()
Mensaje.main()

