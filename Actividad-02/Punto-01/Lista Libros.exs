defmodule Biblioteca do
  def main do
    libros = [
  %{codigo: "LB001",
    titulo: "Cien años de soledad",
    autor: "García Márquez",
    genero: "Novela",
    paginas: 432,
    precio: 45000,
    copias: 320,
    disponible: true},

  %{codigo: "LB002",
    titulo: "El principito",
    autor: "Saint-Exupéry",
    genero: "Infantil",
    paginas: 96,
    precio: 28000,
    copias: 510,
    disponible: true},

  %{codigo: "LB003",
    titulo: "Sapiens",
    autor: "Harari",
    genero: "Historia",
    paginas: 560,
    precio: 62000,
    copias: 280,
    disponible: false},

  %{codigo: "LB004",
    titulo: "1984",
    autor: "Orwell",
    genero: "Novela",
    paginas: 328,
    precio: 38000,
    copias: 195,
    disponible: true},

  %{codigo: "LB005",
    titulo: "El gen egoísta",
    autor: "Dawkins",
    genero: "Ciencia",
    paginas: 504,
    precio: 55000,
    copias: 140,
    disponible: false},

  %{codigo: "LB006",
    titulo: "Harry Potter",
    autor: "Rowling",
    genero: "Fantasía",
    paginas: 223,
    precio: 42000,
    copias: 630,
    disponible: true},

  %{codigo: "LB007",
    titulo: "Breve historia del tiempo",
    autor: "Hawking",
    genero: "Ciencia",
    paginas: 212,
    precio: 50000,
    copias: 175,
    disponible: true},

  %{codigo: "LB008",
    titulo: "Don Quijote",
    autor: "Cervantes",
    genero: "Novela",
    paginas: 863,
    precio: 70000,
    copias: 98,
    disponible: false},

  %{codigo: "LB009",
    titulo: "Atomic Habits",
    autor: "Clear",
    genero: "Autoayuda",
    paginas: 319,
    precio: 48000,
    copias: 420,
    disponible: true},

  %{codigo: "LB010",
    titulo: "El alquimista",
    autor: "Coelho",
    genero: "Novela",
    paginas: 177,
    precio: 32000,
    copias: 380,
    disponible: true}
  ]

  libros_disponibles = filtar_disponibilidad(libros)
  IO.inspect(libros_disponibles)

  libros_agrupados_genero = agrupar_genero(libros)
  IO.inspect(libros_agrupados_genero)

  reporte = imprimir_formato(libros)
  IO.inspect(reporte)

  libros_precio_limite = filtrar_precio_limite(libros, 50000)
  IO.inspect(libros_precio_limite)

  generos_mas_paginas = filtrar_genero_paginas(libros)
  IO.inspect(generos_mas_paginas)

  libros_rentables = definir_rentabilidad(libros)
  IO.inspect(libros_rentables)

  mapas_cortos = mapear_libros(libros)
  IO.inspect(mapas_cortos)

  end

  def filtar_disponibilidad(lista) do
    Enum.filter(lista, fn l -> l.disponible end)
    |>Enum.map(fn l -> l.titulo end)
    |>Enum.sort()
  end

  def agrupar_genero(lista) do
    Enum.group_by(lista, fn l -> l.genero end)
    |>Enum.map(fn {genero, libros} -> {genero, Enum.map(libros, fn l -> l.copias end) |>Enum.sum()} end)
  end

  def imprimir_formato(lista) do
    Enum.filter(lista, fn l-> l.disponible end)
    |>Enum.map( fn l ->
      if l.paginas < 100, do: "#{l.codigo} - #{l.titulo} Con un total de Paginas de #{l.paginas}*",
      else: "#{l.codigo} - #{l.titulo} Con un total de Paginas de #{l.paginas}"
    end)
  end

  def filtrar_precio_limite(lista, precio_limite) do
    Enum.filter(lista, fn l -> l.precio < precio_limite end)
    |>Enum.map(fn l ->
      precio_final =l.precio - (l.precio * 0.15)
      {l.codigo, l.titulo, precio_final}
    end)
    |>Enum.sort_by(fn {_codigo,_titulo, precio} -> precio end)
  end

  def filtrar_genero_paginas(lista) do
    categorizar = fn
      l when l.paginas < 200 -> :corto
      l when l.paginas >= 200 and l.paginas <=500 -> :medio
      l -> :largo
      end

    Enum.group_by(lista, fn  l-> l.genero end)
    |>Enum.filter(fn {_generos, libros} ->
      categorias = libros
      |>Enum.map(categorizar)
      Enum.member?(categorias, :corto) and Enum.member?(categorias, :medio) and Enum.member?(categorias, :largo)
    end)
    |>Enum.map(fn {genero, _,} -> genero end)
  end

  def definir_rentabilidad(lista) do
    Enum.filter(lista, fn l -> l.disponible end)
    |>Enum.group_by(fn l -> l.genero end)
    |>Enum.map(fn {genero, libros} -> {genero, Enum.map(libros, fn l -> l.precio * l.copias end)|>Enum.sum()} end)
    |>Enum.sort_by(fn {_genero, rentabilidad} -> rentabilidad end, :desc)
    |>Enum.take(3)
  end

  def mapear_libros(lista) do
    Enum.map(lista, fn l -> {l.codigo, l.titulo} end)
    |>Enum.into(%{})
  end
  

end
Biblioteca.main()
