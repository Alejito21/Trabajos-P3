defmodule Inventario do
  @csv_file "productos.csv"

  def registrar(inventario, %Producto{} = producto) do
    if Enum.any?(inventario, fn p -> p.codigo == producto.codigo end) do
      IO.puts("Error: el producto ya existe")
      inventario
    else
      nuevo =inventario ++ [producto]
      guardar_csv(nuevo)
      nuevo
    end
  end

  def actualizar_stock(inventario, codigo, delta)do
    case Enum.find_index(inventario, fn p -> p.codigo == codigo end)do
      nil ->
        IO.puts("Error: producto no encontrado")
        inventario
      index ->
        actualizado =
          List.update_at(inventario, index, fn p->
            nuevo_stock = max(0, p.cantidad + delta)
            IO.puts("Producto #{p.nombre} actualizado: #{p.cantidad} -> #{nuevo_stock}")
            %{p | cantidad: nuevo_stock}
          end)
        guardar_csv(actualizado)
        actualizado
    end
  end

  def consultar_categoria(inventario, categoria) do
    resultados = Enum.filter(inventario, fn p -> p.categoria == categoria end)
    if resultados == [] do
      IO.puts("Sin productos para esa categoría")
    else
      Enum.each(resultados, &imprimir_producto/1)
    end
    resultados
  end

  def guardar_csv(inventario) do
    encabezado = "codigo,nombre,categoria,precio,cantidad,fecha_ingreso\n"
    filas = Enum.map_join(inventario, "\n", fn p ->
      "#{p.codigo},#{p.nombre},#{p.categoria},#{p.precio},#{p.cantidad},#{p.fecha_ingreso}"
    end)
    File.write!(@csv_file, encabezado <> filas)
    IO.puts("Se guardo el archivo CSV")
  end

  def cargar_csv() do
    case File.read(@csv_file) do
      {:ok, contenido} ->
        contenido
        |> String.split("\n", trim: true)
        |> Enum.drop(1) # quitar encabezado
        |>Enum.map(&parsear_linea/1)

      {:error, _} ->
        IO.puts("Archivo CSV no encontrado, iniciando inventario vacío")
        []
    end
  end

  defp parsear_linea(linea) do
    [codigo, nombre, categoria, precio, cantidad, fecha_ingreso] = String.split(linea, ",")
    %Producto{
      codigo: String.to_integer(codigo),
      nombre: nombre,
      categoria: categoria,
      precio: String.to_float(precio),
      cantidad: String.to_integer(cantidad),
      fecha_ingreso: fecha_ingreso
    }
  end

  def estado(inventario)do
    total_unidades = Enum.sum(Enum.map(inventario, fn p -> p.cantidad end))
    valor_total = Enum.reduce(inventario, 0.0, fn p, acc ->
      acc + p.precio * p.cantidad
    end)
    IO.puts("Inventario")
    IO.puts("Productos distintos: #{length(inventario)}")
    IO.puts("Total de unidades: #{total_unidades}")
    IO.puts("Valor total del inventario: $#{Float.round(valor_total, 2)}")
  end

  defp imprimir_producto(p) do
     IO.puts("""
      ---
      Código   : #{p.codigo}
      Nombre   : #{p.nombre}
      Categoría: #{p.categoria}
      Precio   : $#{p.precio}
      Stock    : #{p.cantidad} unidades
      Entrada  : #{p.fecha_ingreso}
    """)
  end

  def main do
    inventario = Inventario.cargar_csv()

    inventario =
        inventario
        |> Inventario.registrar(%Producto{
          codigo: "P001", nombre: "Leche Entera", categoria: "Lácteos",
          precio: 3500.0, cantidad: 50, fecha_ingreso: "2025-05-01"
        })
        |> Inventario.registrar(%Producto{
          codigo: "P002", nombre: "Pan Integral", categoria: "Panadería",
          precio: 2800.0, cantidad: 30, fecha_ingreso: "2025-05-10"
        })
        |> Inventario.registrar(%Producto{
          codigo: "P003", nombre: "Queso Doble Crema", categoria: "Lácteos",
          precio: 8000.0, cantidad: 20, fecha_ingreso: "2025-05-10"
        })

    inventario = Inventario.actualizar_stock(inventario, "P001", -10)
    inventario = Inventario.actualizar_stock(inventario, "P002", 15)

    Inventario.consultar_categoria(inventario, "Lácteos")
    Inventario.estado(inventario)
  end
end
Inventario.main()
