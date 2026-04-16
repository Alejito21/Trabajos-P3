defmodule ContarVocales do
  def main do
    frase = "Holaaaa"
    IO.puts("Número de vocales: #{contarVocales(frase)}")
    IO.puts("Número de vocales (recursivo): #{contarVocales2(frase)}")
  end

  def contarVocales(frase) do
    frase
    |> String.graphemes()
    |> Enum.reduce(0, fn char, acc ->
      if char in ["a", "e", "i", "o", "u"] do
        acc + 1
      else
        acc
      end
    end)
  end

  def contarVocales2(""), do: 0

  def contarVocales2(frase) do
    frase_minuscula = String.downcase(frase)
    {char, rest} = String.split_at(frase_minuscula, 1)

    if char in ["a", "e", "i", "o", "u"] do
      1 + contarVocales2(rest)
    else
      contarVocales2(rest)
    end
  end

end
ContarVocales.main()
