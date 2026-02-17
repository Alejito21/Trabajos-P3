defmodule Util do
  def mostrar_mensaje(mensaje) do
    mensaje
    |> IO.puts()
  end

  def ingresar(frase, :texto) do
    frase
    |> IO.gets()
    |> String.trim()
  end
end
