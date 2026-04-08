defmodule ListaRecursiva do
  def main do
    lista = [1,2,3,4,5,6,"Algo", :atom]
    imprimir_lista(lista)
  end

  def imprimir_lista(lista) do
    cabeza = hd(lista)
    cola = tl(lista)
    IO.puts(cabeza)
    if length(cola) > 0 do
      imprimir_lista(cola)
    end
  end

end
ListaRecursiva.main()



