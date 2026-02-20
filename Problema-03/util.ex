defmodule Util do
@moduledoc """
Módulo con funciones que se reutilizan
- Autor: Alejandro Rivera Pérez.
- Fecha: 19 Febrero 2026.
- Licencia: GNU GPL v3
"""
  def ingresar(mensaje, :texto) do
    mensaje
    |> IO.gets()
    |> String.trim()
  end

  def ingresar(mensaje, :entero) do
    try do
      mensaje
      |> ingresar(:texto)
      |> String.to_integer()
    rescue
      ArgumentError ->
        "Error, se espera que ingrese un número entero\n"
        |> mostrar_error()
        mensaje
        |> ingresar(:entero)
    end
  end

  def mostrar_error(mensaje) do
    IO.puts(:standard_error, mensaje)
  end

  def mostrar_mensaje(mensaje) do
    mensaje
    |> IO.puts()
  end

end
