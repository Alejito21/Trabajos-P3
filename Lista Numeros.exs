defmodule ListaNumerosCRUD do

  "Agrega numeros a una lista"
  def created(lista, numero) do
    lista ++ [numero]
  end

  "Lee la lista de numeros"
  def read(lista) do
    lista
  end

  "Busca un numero en la lista"
  def search(lista, numero) do
    Enum.member?(lista, numero)
  end

  "Actualiza un numero viejo de la lista por un numero nuevo"
  def update(lista, viejo, nuevo) do
    Enum.map(lista, fn x -> if x == viejo, do: nuevo, else: x end)
  end

  "Elimina un numero de la lista"
  def delete(lista, numero) do
    Enum.filter(lista, fn x -> x != numero end)
  end


end

listaX = [1,2,3]
listaNueva = ListaNumerosCRUD.created(listaX, 4)
IO.inspect(listaNueva)
listaCambiada = ListaNumerosCRUD.update(listaX, 2,5)
IO.inspect(listaCambiada)
IO.inspect(ListaNumerosCRUD.search(listaX,2))
listaEliminada = ListaNumerosCRUD.delete(listaX,1)
IO.inspect(listaEliminada)
hd(listaNueva)
tl(listaNueva)
IO.inspect(tl(listaNueva))
