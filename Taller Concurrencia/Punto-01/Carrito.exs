defmodule Carrito do
  @csv_file "carrito.csv"

  def iniciar do
    items = cargar_csv()
    spawn (fn -> loop(items) end)
  end

  def agregar(pid, item) do
    send(pid, {:agregar, item})
  end

  def quitar(pid, id) do
    send(pid, {:quitar, id})
  end

  def total(pid)do
    send(pid, {:total, self()})
  end

  def listar(pid) do
    send(pid, {:listar, self()})
  end

  def guardar_carrito(pid) do
    send(pid, :guardar_carrito)
  end

  def vaciar(pid) do
    send(pid, :vaciar)
  end

  def detener(pid) do
    send(pid, :detener)
  end


  def loop(items)do
    receive do
      {:agregar, item} ->
        items_actualizados =

          case Enum.find_index(items, &(&1.id == item.id)) do
            nil ->
              items ++ [item]
            idx ->
              List.update_at(items, idx, fn existente ->
                %{existente | cantidad: existente.cantidad + item.cantidad}
              end)
          end

        loop(items_actualizados)

      {:quitar, id} ->
        loop(Enum.reject(items, &(&1.id == id)))

      {:total, pid} ->
        total = Enum.reduce(items, 0.0, fn item, acc -> acc + (item.cantidad * item.precio_unitario) end)
        send(pid, {:total, total})
        loop(items)

      {:listar, pid} ->
        send(pid, {:listar, items})
        loop(items)

      :guardar_carrito ->
        escribir_csv(items)
        loop(items)

      :vaciar ->
        loop([])

      :detener ->
        :ok
    end
  end

  defp escribir_csv(items) do
    encabezado = "id,nombre,cantidad,precio\n"
    filas = Enum.map_join(items, "\n", fn item ->
      "#{item.id},#{item.nombre},#{item.cantidad},#{item.precio_unitario}"
    end)
    File.write!(@csv_file, encabezado <> filas)
    IO.puts("El Carrito fue guardado en el archivo #{@csv_file}")
  end

  defp cargar_csv do
    case File.read(@csv_file) do
      {:ok, contenido} ->
        contenido
        |> String.split("\n", trim: true)
        |> Enum.drop(1)
        |> Enum.map(&parsear_linea/1)
      {:error, _} ->
        IO.puts("No se encontró #{@csv_file}. Iniciando con carrito vacío.")
        []
    end
  end


  defp parsear_linea(linea) do
    [id, nombre, cantidad, precio] = String.split(linea, ",")
    %Item{
      id: String.to_integer(id),
      nombre: nombre,
      cantidad: String.to_integer(cantidad),
      precio_unitario: String.to_float(precio)
    }
  end

  def main do
    pid = iniciar()

    item1 = %Item{id: 1, nombre: "Manzana", cantidad: 2, precio_unitario: 1.5}
    agregar(pid, item1)

    item2 = %Item{id: 2, nombre: "Banana", cantidad: 3, precio_unitario: 0.8}
    agregar(pid, item2)

    # Agregar otro item con mismo id para probar actualización de cantidad
    item3 = %Item{id: 1, nombre: "Manzana", cantidad: 1, precio_unitario: 1.5}
    agregar(pid, item3)

    listar(pid)
    receive do
      {:listar, items} -> IO.inspect(items, label: "Items en el carrito")
    end

    total(pid)
    receive do
      {:total, total} -> IO.puts("Total: #{total}")
    end

    guardar_carrito(pid)

    # Quitar un item
    quitar(pid, 2)

    listar(pid)
    receive do
      {:listar, items} -> IO.inspect(items, label: "Items después de quitar Banana")
    end

    total(pid)
    receive do
      {:total, total} -> IO.puts("Total después de quitar: #{total}")
    end

    vaciar(pid)

    listar(pid)
    receive do
      {:listar, items} -> IO.inspect(items, label: "Items después de vaciar")
    end

    detener(pid)
  end

end
Carrito.main()
