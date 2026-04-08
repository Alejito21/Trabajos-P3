defmodule Aerolineas do
  def main do
    lista_vuelos = [

      %{
        codigo: "AV201",
        aerolinea: "Avianca",
        origen: "BOG",
        destino: "MDE",
        duracion: 45,
        precio: 180000,
        pasajeros: 120,
        disponible: true
      },

      %{
        codigo: "LA305",
        aerolinea: "Latam",
        origen: "BOG",
        destino: "CLO",
        duracion: 55,
        precio: 210000,
        pasajeros: 98,
        disponible: true
      },

      %{
        codigo: "AV410",
        aerolinea: "Avianca",
        origen: "MDE",
        destino: "CTG",
        duracion: 75,
        precio: 320000,
        pasajeros: 134,
        disponible: false
      },

      %{
        codigo: "VV102",
        aerolinea: "Viva Air",
        origen: "BOG",
        destino: "BAQ",
        duracion: 90,
        precio: 145_000,
        pasajeros: 180,
        disponible: true
      },

      %{
        codigo: "LA512",
        aerolinea: "Latam",
        origen: "CLO",
        destino: "CTG",
        duracion: 110,
        precio: 480_000,
        pasajeros: 76,
        disponible: false
      },

      %{
        codigo: "AV330",
        aerolinea: "Avianca",
        origen: "BOG",
        destino: "CTG",
        duracion: 135,
        precio: 520_000,
        pasajeros: 155,
        disponible: true
      },

      %{
        codigo: "VV215",
        aerolinea: "Viva Air",
        origen: "MDE",
        destino: "BOG",
        duracion: 50,
        precio: 130_000,
        pasajeros: 190,
        disponible: true
      },

      %{
        codigo: "LA620",
        aerolinea: "Latam",
        origen: "BOG",
        destino: "MDE",
        duracion: 145,
        precio: 390_000,
        pasajeros: 112,
        disponible: true
      },

      %{
        codigo: "AV505",
        aerolinea: "Avianca",
        origen: "CTG",
        destino: "BOG",
        duracion: 120,
        precio: 440_000,
        pasajeros: 143,
        disponible: false
      },

      %{
        codigo: "VV340",
        aerolinea: "Viva Air",
        origen: "BAQ",
        destino: "BOG",
        duracion: 85,
        precio: 160_000,
        pasajeros: 175,
        disponible: true
      }
    ]

    vuelos_disponibles = filtrar_vuelos_disponibles(lista_vuelos)
    IO.inspect(vuelos_disponibles)

    pasajeros_por_aerolinea = agrupar_aerolinea(lista_vuelos)
    IO.inspect(pasajeros_por_aerolinea)

    formato_vuelos = exportar_formato(lista_vuelos)
    IO.inspect(formato_vuelos)

    vuelos_limite_400000 = filtrar_precio_limite(lista_vuelos, 400000)
    IO.inspect(vuelos_limite_400000)

    vuelos_tres_categorias = agrupar_categorias(lista_vuelos)
    IO.inspect(vuelos_tres_categorias)

    vuelos_rentables= filtrar_rutas_rentables(lista_vuelos)
    IO.inspect(vuelos_rentables)

  end

  def filtrar_vuelos_disponibles(lista) do
    Enum.filter(lista, fn v -> v.disponible end) #Genera una nueva lista con solo los vuelos disponibles.
    |>Enum.map(fn v -> v.codigo end) #Genera una nueva lista con los codigos de los vuelos.
    |>Enum.sort() #Los ordenba alfabeticamente.
  end

  def agrupar_aerolinea(lista) do
    Enum.group_by(lista, fn v -> v.aerolinea end) #Genera un mapa donde la clave es la aerolinea y el valor es una lista de vuelos de esa aerolinea.
    |>Enum.map(fn {aerolinea, vuelos} -> {aerolinea, Enum.map(vuelos, fn v -> v.pasajeros end) |>Enum.sum()} end) #Genera una tupla con la aerolinea y su total de pasajeros.
    |>Enum.into(%{}) #Pasa la lista de tuplas a un mapa.
  end

  def exportar_formato(lista) do
    Enum.map(lista, fn v ->
      horas = div(v.duracion, 60)
      minutos = rem(v.duracion, 60)
      if minutos <10, do: "#{v.codigo} #{v.origen} -> #{v.destino} 0#{minutos}m",
      else: "#{v.codigo} #{v.origen} -> #{v.destino} (#{horas}h #{minutos}m)"
      end) #
  end

  def filtrar_precio_limite(lista, limite) do
    Enum.filter(lista, fn v -> v.precio < limite end)
    |>Enum.map(fn v ->
    precio_final = v.precio*0.10
    {v.codigo, "#{v.origen} -> #{v.destino}", precio_final} end)
    |>Enum.sort_by(fn {_, _, precio} -> precio end)
  end

  def agrupar_categorias(lista) do
    categorizar = fn
      v when v.duracion < 60 -> :corto
      v when v.duracion >= 60 and v.duracion < 120 -> :medio
      v -> :largo
      end

    Enum.group_by(lista, fn v -> v.aerolinea end)
    |>Enum.filter(fn {_aerolinea, vuelos} ->
        categorias = vuelos
        |>Enum.map(categorizar)
        |>Enum.uniq()
        Enum.member?(categorias, :corto) and Enum.member?(categorias, :medio) and Enum.member?(categorias, :largo)
    end)
    |>Enum.map(fn {aerolinea, _} -> aerolinea end)
  end

  def filtrar_rutas_rentables(lista) do
    Enum.filter(lista, fn v -> v.disponible end)
    |>Enum.group_by(fn v -> "#{v.origen} #{v.destino}" end)
    |>Enum.map(fn {ruta, vuelos} -> {ruta, Enum.map(vuelos, fn v -> v.precio * v.pasajeros end) |> Enum.sum()}end)
    |>Enum.sort_by(fn {_ruta, tasa }-> tasa end, :desc)
    |>Enum.take(3)
  end

end



Aerolineas.main()
