defmodule VerificarContrasena do
  def main do
  end

  def pedir_contrasena do
    contrasena = IO.gets("Ingrese la contraseña: ") |> String.trim()
    case verficar_contrasena(contrasena) do
      :ok -> IO.puts("Contraseña correcta.")
      {:error, motivo} ->
        IO.puts("Contraseña incorrecta. Intente nuevamente.")
        pedir_contrasena()
    end
  end

  def verficar_contrasena(contrasena) do
    cond do
      String.length(contrasena) < 6 ->
        {:error, "La contraseña debe tener al menos 6 caracteres."}
      not tiene_mayuscula?(String.graphemes(contrasena)) ->
        {:error, "La contraseña debe contener al menos una letra mayúscula."}
      not tiene_digito?(String.graphemes(contrasena)) ->
        {:error, "La contraseña debe contener al menos un dígito."}
      not tiene_caracter_especial?(String.graphemes(contrasena)) ->
        {:error, "La contraseña debe contener al menos un carácter especial."}
      true ->
        :ok
    end
  end

  def tiene_mayuscula([]), do: false
  def tiene_mayuscula([h | t]) do
    if String.downcase(h) != h and h == String.upcase(h) do
      true
    else
      tiene_mayuscula(t)
    end
  end

  def tiene_digito([]), do: false
  def tiene_digito([h | t]) do
    if h in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] do
      true
    else
      tiene_digito(t)
    end
  end

  def tiene_caracter_especial([]), do: false
  def tiene_caracter_especial([h | t]) do
    if h in ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "+", "="] do
      true
    else
      tiene_caracter_especial(t)
    end
  end



end
