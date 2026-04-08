# =============================================================================
# PRÁCTICA ELIXIR — Listas y Mapas
# Cómo correr:
#   - Modo script:  elixir practica_elixir.exs
#   - En IEx:       iex practica_elixir.exs  (o  c "practica_elixir.exs"  en IEx)
# =============================================================================

# -----------------------------------------------------------------------------
# DATOS BASE — empleados y otros contextos de ejemplo
# -----------------------------------------------------------------------------

empleados = [
  %{id: 1, nombre: "Ana Torres",  cargo: "Desarrolladora", salario: 3_500, activo: true},
  %{id: 2, nombre: "Luis Gómez",  cargo: "QA Engineer",    salario: 2_800, activo: true},
  %{id: 3, nombre: "Marta Ríos",  cargo: "Diseñadora",     salario: 3_100, activo: false},
  %{id: 4, nombre: "Pedro Vela",  cargo: "Desarrollador",  salario: 3_800, activo: true},
  %{id: 5, nombre: "Sara Nieto",  cargo: "DevOps",         salario: 4_200, activo: true}
]

IO.puts("\n" <> String.duplicate("=", 60))
IO.puts("  DATOS BASE")
IO.puts(String.duplicate("=", 60))
IO.inspect(empleados, label: "empleados")


# =============================================================================
# SECCIÓN 1 — LIST: LEER Y BUSCAR
# =============================================================================

IO.puts("\n" <> String.duplicate("=", 60))
IO.puts("  SECCIÓN 1 · List — leer y buscar")
IO.puts(String.duplicate("=", 60))


# --- 1.1  Primer y último elemento -------------------------------------------
IO.puts("\n--- 1.1  List.first / List.last / hd / tl ---")

IO.inspect(List.first(empleados),  label: "List.first")
IO.inspect(List.last(empleados),   label: "List.last")
IO.inspect(hd(empleados),          label: "hd (cabeza)")
IO.inspect(tl(empleados),          label: "tl (cola — el resto)")


# --- 1.2  Contar elementos ---------------------------------------------------
IO.puts("\n--- 1.2  length / Enum.count / Enum.empty? ---")

IO.inspect(length(empleados),                                    label: "length total")
IO.inspect(Enum.count(empleados),                                label: "Enum.count total")
IO.inspect(Enum.count(empleados, fn e -> e.activo end),          label: "Enum.count activos")
IO.inspect(Enum.empty?(empleados),                               label: "Enum.empty? empleados")
IO.inspect(Enum.empty?([]),                                      label: "Enum.empty? lista vacía")


# --- 1.3  Buscar con Enum.find -----------------------------------------------
IO.puts("\n--- 1.3  Enum.find / Enum.any? / Enum.all? ---")

# Devuelve el primer elemento que cumple la condición, o nil
IO.inspect(Enum.find(empleados, fn e -> e.id == 3 end),
           label: "find id=3")

IO.inspect(Enum.find(empleados, fn e -> e.id == 99 end),
           label: "find id=99 (no existe → nil)")

# Buscar por nombre parcial
IO.inspect(Enum.find(empleados, fn e -> String.starts_with?(e.nombre, "Sara") end),
           label: "find nombre empieza 'Sara'")

IO.inspect(Enum.any?(empleados, fn e -> e.cargo == "DevOps" end),
           label: "any? hay DevOps")

IO.inspect(Enum.all?(empleados, fn e -> e.salario > 2_000 end),
           label: "all? salario > 2000")

IO.inspect(Enum.all?(empleados, fn e -> e.activo end),
           label: "all? todos activos (falso porque Marta está inactiva)")


# --- 1.4  Acceder por índice -------------------------------------------------
IO.puts("\n--- 1.4  Enum.at / Enum.fetch ---")

IO.inspect(Enum.at(empleados, 0),    label: "Enum.at índice 0")
IO.inspect(Enum.at(empleados, -1),   label: "Enum.at índice -1 (último)")
IO.inspect(Enum.at(empleados, 99),   label: "Enum.at índice 99 (→ nil)")

# fetch devuelve {:ok, valor} o :error — más seguro para pattern matching
IO.inspect(Enum.fetch(empleados, 2), label: "Enum.fetch índice 2")
IO.inspect(Enum.fetch(empleados, 99),label: "Enum.fetch índice 99")


# =============================================================================
# SECCIÓN 2 — LIST: CREAR, ELIMINAR, ACTUALIZAR
# =============================================================================

IO.puts("\n" <> String.duplicate("=", 60))
IO.puts("  SECCIÓN 2 · List — crear, eliminar, actualizar")
IO.puts(String.duplicate("=", 60))


# --- 2.1  CREATE — agregar empleados ----------------------------------------
IO.puts("\n--- 2.1  [nuevo | lista]  /  lista ++ [nuevo]  /  List.insert_at ---")

nuevo = %{id: 6, nombre: "Carlos Duque", cargo: "PM", salario: 4_500, activo: true}

# Al inicio — O(1), es la forma preferida en Elixir
con_nuevo_inicio = [nuevo | empleados]
IO.inspect(length(con_nuevo_inicio), label: "largo tras agregar al inicio")
IO.inspect(List.first(con_nuevo_inicio).nombre, label: "primero ahora")

# Al final — O(n)
con_nuevo_final = empleados ++ [nuevo]
IO.inspect(List.last(con_nuevo_final).nombre, label: "último tras agregar al final")

# En posición específica (índice 2)
con_nuevo_medio = List.insert_at(empleados, 2, nuevo)
IO.inspect(Enum.at(con_nuevo_medio, 2).nombre, label: "en posición 2")

# Los originales no cambian — las listas son inmutables
IO.inspect(length(empleados), label: "empleados original sigue siendo")


# --- 2.2  DELETE — eliminar empleados ----------------------------------------
IO.puts("\n--- 2.2  Enum.reject  /  List.delete_at ---")

# Eliminar por condición de campo (la forma más común)
sin_marta = Enum.reject(empleados, fn e -> e.id == 3 end)
IO.inspect(length(sin_marta),         label: "largo tras borrar id=3")
IO.inspect(Enum.map(sin_marta, & &1.nombre), label: "nombres restantes")

# Eliminar empleados inactivos
solo_activos = Enum.reject(empleados, fn e -> not e.activo end)
IO.inspect(Enum.map(solo_activos, & &1.nombre), label: "solo activos")

# Eliminar por índice
sin_primero = List.delete_at(empleados, 0)
IO.inspect(List.first(sin_primero).nombre, label: "primero tras delete_at 0")

# Borrar por coincidencia exacta del mapa completo
e3 = Enum.find(empleados, & &1.id == 3)
sin_e3 = List.delete(empleados, e3)
IO.inspect(length(sin_e3), label: "largo tras List.delete mapa exacto")


# --- 2.3  UPDATE — actualizar empleados --------------------------------------
IO.puts("\n--- 2.3  Enum.map + %{mapa | clave: valor} ---")

# Actualizar un empleado por id
actualizado = Enum.map(empleados, fn e ->
  if e.id == 2, do: %{e | salario: 3_200}, else: e
end)

IO.inspect(
  Enum.find(actualizado, & &1.id == 2).salario,
  label: "salario de Luis tras update"
)

# Aumento del 10% a todos los activos
con_aumento = Enum.map(empleados, fn e ->
  if e.activo, do: %{e | salario: round(e.salario * 1.1)}, else: e
end)

IO.inspect(
  Enum.map(con_aumento, fn e -> {e.nombre, e.salario} end),
  label: "salarios tras aumento 10% activos"
)

# Marcar inactivos a todos los QA
sin_qa_activos = Enum.map(empleados, fn e ->
  if e.cargo == "QA Engineer", do: %{e | activo: false}, else: e
end)

IO.inspect(
  Enum.find(sin_qa_activos, & &1.id == 2).activo,
  label: "Luis activo después? (era QA)"
)


# =============================================================================
# SECCIÓN 3 — LIST: TRANSFORMAR (map / filter / reduce)
# =============================================================================

IO.puts("\n" <> String.duplicate("=", 60))
IO.puts("  SECCIÓN 3 · List — transformar")
IO.puts(String.duplicate("=", 60))


# --- 3.1  Enum.filter --------------------------------------------------------
IO.puts("\n--- 3.1  Enum.filter ---")

activos = Enum.filter(empleados, fn e -> e.activo end)
IO.inspect(Enum.map(activos, & &1.nombre), label: "activos")

devs_senior = Enum.filter(empleados, fn e ->
  String.contains?(e.cargo, "Desar") and e.salario > 3_500
end)
IO.inspect(Enum.map(devs_senior, & &1.nombre), label: "devs con salario > 3500")


# --- 3.2  Enum.map -----------------------------------------------------------
IO.puts("\n--- 3.2  Enum.map ---")

nombres = Enum.map(empleados, & &1.nombre)
IO.inspect(nombres, label: "solo nombres")

# Con captura de función
salarios = Enum.map(empleados, & &1.salario)
IO.inspect(salarios, label: "solo salarios")

# Proyección compuesta: tupla {id, nombre}
ids_nombres = Enum.map(empleados, fn e -> {e.id, e.nombre} end)
IO.inspect(ids_nombres, label: "tuplas {id, nombre}")

# Transformar el mapa: agregar campo :nombre_upper
con_upper = Enum.map(empleados, fn e ->
  Map.put(e, :nombre_upper, String.upcase(e.nombre))
end)
IO.inspect(Enum.map(con_upper, & &1.nombre_upper), label: "nombres en mayúscula")


# --- 3.3  Enum.reduce --------------------------------------------------------
IO.puts("\n--- 3.3  Enum.reduce ---")

total_salarios = Enum.reduce(empleados, 0, fn e, acc -> acc + e.salario end)
IO.inspect(total_salarios, label: "total salarios (reduce)")

# Forma más corta con pipe
total_pipe = empleados |> Enum.map(& &1.salario) |> Enum.sum()
IO.inspect(total_pipe, label: "total salarios (map + sum)")

promedio = total_pipe / length(empleados)
IO.inspect(Float.round(promedio, 2), label: "promedio salarial")

# Acumular nombres en un string
resumen = Enum.reduce(empleados, "", fn e, acc ->
  if acc == "", do: e.nombre, else: acc <> ", " <> e.nombre
end)
IO.inspect(resumen, label: "nombres concatenados")


# --- 3.4  Enum.sort_by / min_by / max_by ------------------------------------
IO.puts("\n--- 3.4  Enum.sort_by / min_by / max_by ---")

por_salario_asc  = Enum.sort_by(empleados, & &1.salario)
por_salario_desc = Enum.sort_by(empleados, & &1.salario, :desc)
por_nombre       = Enum.sort_by(empleados, & &1.nombre)

IO.inspect(Enum.map(por_salario_asc,  & &1.nombre), label: "por salario ASC")
IO.inspect(Enum.map(por_salario_desc, & &1.nombre), label: "por salario DESC")
IO.inspect(Enum.map(por_nombre,       & &1.nombre), label: "por nombre A-Z")

IO.inspect(Enum.max_by(empleados, & &1.salario).nombre, label: "mayor salario")
IO.inspect(Enum.min_by(empleados, & &1.salario).nombre, label: "menor salario")


# --- 3.5  Enum.group_by / frequencies_by / uniq_by --------------------------
IO.puts("\n--- 3.5  Enum.group_by / frequencies_by / uniq_by / take ---")

por_cargo = Enum.group_by(empleados, & &1.cargo)
IO.inspect(Map.keys(por_cargo), label: "cargos (claves del group)")

# group_by con proyección: solo guardar el nombre en cada grupo
cargos_nombres = Enum.group_by(empleados, & &1.cargo, & &1.nombre)
IO.inspect(cargos_nombres, label: "cargos → nombres")

por_activo = Enum.group_by(empleados, & &1.activo)
IO.inspect(Enum.map(por_activo[true],  & &1.nombre), label: "activos (true)")
IO.inspect(Enum.map(por_activo[false], & &1.nombre), label: "inactivos (false)")

frecuencias = Enum.frequencies_by(empleados, & &1.cargo)
IO.inspect(frecuencias, label: "frecuencias por cargo")

cargos_unicos = empleados |> Enum.map(& &1.cargo) |> Enum.uniq()
IO.inspect(cargos_unicos, label: "cargos únicos")

top3 = empleados |> Enum.sort_by(& &1.salario, :desc) |> Enum.take(3)
IO.inspect(Enum.map(top3, & &1.nombre), label: "top 3 salarios")


# =============================================================================
# SECCIÓN 4 — MAP: OPERACIONES
# =============================================================================

IO.puts("\n" <> String.duplicate("=", 60))
IO.puts("  SECCIÓN 4 · Map — operaciones")
IO.puts(String.duplicate("=", 60))

e = List.first(empleados)   # %{id: 1, nombre: "Ana Torres", ...}


# --- 4.1  Leer valores -------------------------------------------------------
IO.puts("\n--- 4.1  Leer: .campo  /  [:clave]  /  Map.get  /  Map.fetch ---")

IO.inspect(e.nombre,                         label: "e.nombre  (lanza error si no existe)")
IO.inspect(e[:nombre],                       label: "e[:nombre]  (nil si no existe)")
IO.inspect(Map.get(e, :nombre),              label: "Map.get nombre")
IO.inspect(Map.get(e, :email, "sin email"),  label: "Map.get email con default")
IO.inspect(Map.fetch(e, :salario),           label: "Map.fetch salario → {:ok, val}")
IO.inspect(Map.fetch(e, :email),             label: "Map.fetch email → :error")
IO.inspect(Map.has_key?(e, :cargo),          label: "Map.has_key? :cargo")
IO.inspect(Map.has_key?(e, :email),          label: "Map.has_key? :email")


# --- 4.2  Agregar y eliminar claves ------------------------------------------
IO.puts("\n--- 4.2  Map.put / Map.delete / Map.merge ---")

con_email = Map.put(e, :email, "ana@empresa.com")
IO.inspect(con_email, label: "Map.put añade :email")

sin_activo = Map.delete(e, :activo)
IO.inspect(Map.keys(sin_activo), label: "claves tras Map.delete :activo")

# merge: el segundo mapa sobreescribe claves en conflicto
fusionado = Map.merge(e, %{salario: 4_000, nivel: "Senior"})
IO.inspect({fusionado.salario, fusionado[:nivel]}, label: "tras merge {salario, nivel}")


# --- 4.3  Actualizar valores -------------------------------------------------
IO.puts("\n--- 4.3  %{mapa | clave: val}  /  Map.update  /  Map.update! ---")

# Sintaxis de actualización — solo funciona para claves que YA existen
e_actualizado = %{e | salario: 5_000, activo: false}
IO.inspect({e_actualizado.salario, e_actualizado.activo}, label: "update sintaxis mapa")

# Map.update/4 — permite transformar el valor existente; default si no existe
e_aumento = Map.update(e, :salario, 0, fn s -> round(s * 1.15) end)
IO.inspect(e_aumento.salario, label: "Map.update aumento 15%")

# Map.update!/3 — lanza KeyError si la clave no existe (más seguro)
e_bonus = Map.update!(e, :salario, fn s -> s + 500 end)
IO.inspect(e_bonus.salario, label: "Map.update! bonus +500")


# --- 4.4  Inspeccionar estructura --------------------------------------------
IO.puts("\n--- 4.4  Map.keys / Map.values / Map.to_list ---")

IO.inspect(Map.keys(e),    label: "Map.keys")
IO.inspect(Map.values(e),  label: "Map.values")
IO.inspect(Map.to_list(e), label: "Map.to_list (lista de tuplas)")


# --- 4.5  Convertir lista → mapa indexado ------------------------------------
IO.puts("\n--- 4.5  Map.new / Enum.into — indexar por id ---")

# Muy útil para búsquedas frecuentes por id (O(1) en vez de O(n))
indice = Map.new(empleados, fn e -> {e.id, e} end)
IO.inspect(indice[1].nombre,  label: "indice[1].nombre")
IO.inspect(indice[4].nombre,  label: "indice[4].nombre")
IO.inspect(indice[99],        label: "indice[99] (no existe → nil)")

# Enum.into — índice id → nombre
id_a_nombre = Enum.into(empleados, %{}, fn e -> {e.id, e.nombre} end)
IO.inspect(id_a_nombre, label: "mapa id → nombre")


# =============================================================================
# SECCIÓN 5 — CONTEXTO EXTRA: carrito de compras
# =============================================================================

IO.puts("\n" <> String.duplicate("=", 60))
IO.puts("  SECCIÓN 5 · Extra — carrito de compras")
IO.puts(String.duplicate("=", 60))

carrito = [
  %{producto: "Teclado",  precio: 85.0,  cantidad: 1},
  %{producto: "Mouse",    precio: 35.0,  cantidad: 2},
  %{producto: "Monitor",  precio: 320.0, cantidad: 1},
  %{producto: "Webcam",   precio: 60.0,  cantidad: 1}
]

total = Enum.reduce(carrito, 0.0, fn item, acc ->
  acc + item.precio * item.cantidad
end)
IO.inspect(Float.round(total, 2), label: "total carrito")

# Descuento del 10%
con_descuento = Enum.map(carrito, fn item ->
  %{item | precio: Float.round(item.precio * 0.9, 2)}
end)
IO.inspect(Enum.map(con_descuento, fn i -> {i.producto, i.precio} end),
           label: "precios tras 10% descuento")

# Artículos caros (precio > 100)
caros = Enum.filter(carrito, fn i -> i.precio > 100 end)
IO.inspect(Enum.map(caros, & &1.producto), label: "productos precio > 100")

# Producto más caro
IO.inspect(Enum.max_by(carrito, & &1.precio).producto, label: "producto más caro")

# Ordenar por precio descendente
IO.inspect(
  carrito |> Enum.sort_by(& &1.precio, :desc) |> Enum.map(& &1.producto),
  label: "productos por precio DESC"
)


IO.puts("\n" <> String.duplicate("=", 60))
IO.puts("  FIN — ¡practica modificando los valores y funciones!")
IO.puts(String.duplicate("=", 60) <> "\n")
