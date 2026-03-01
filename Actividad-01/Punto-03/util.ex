defmodule  Util do
  @moduledoc """
Módulo con funciones que se reutilizan
- Autor: Alejandro Rivera Pérez.
- Fecha: 19 Febrero 2026.
- Licencia: GNU GPL v3
"""
  def ingresar(mensaje, :texto)do
    mensaje
    |>IO.gets()
    |>String.trim()
  end

  def ingresar(mensaje, :entero)do
    ingresar(mensaje,
    &String.to_integer/1,
    :entero)

  end

  def ingresar(mensaje, :real)do
    ingresar(mensaje,
    &String.to_float/1,
    :real)
  end

  defp ingresar(mensaje, parser, tipo_dato)do
    try do
      mensaje
      |>ingresar(:texto)
      |>parser.()
    rescue
      ArgumentError ->
        "Error, se espera que se ingresa el siguiente dato:  #{tipo_dato}\n"
        |> mostrar_error()

        mensaje
        |> ingresar(parser, tipo_dato)

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
