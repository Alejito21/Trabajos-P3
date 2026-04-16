defmodule TorneoVideojuegos do
  def main do

    torneos = [
  %{codigo: "T001", juego: "League of Legends", organizador: "ESL",
    pais: "Colombia", participantes: 128, premio: 5000000, duracion_dias: 3, activo: true},
  %{codigo: "T002", juego: "Valorant", organizador: "Riot",
    pais: "México", participantes: 64, premio: 3200000, duracion_dias: 1, activo: true},
  %{codigo: "T003", juego: "FIFA", organizador: "EA Sports",
    pais: "Colombia", participantes: 256, premio: 8000000, duracion_dias: 5, activo: false},
  %{codigo: "T004", juego: "League of Legends", organizador: "ESL",
    pais: "Argentina", participantes: 96, premio: 4500000, duracion_dias: 3, activo: true},
  %{codigo: "T005", juego: "Fortnite", organizador: "Epic",
    pais: "Colombia", participantes: 200, premio: 6000000, duracion_dias: 4, activo: false},
  %{codigo: "T006", juego: "Valorant", organizador: "Riot",
    pais: "Argentina", participantes: 80, premio: 2800000, duracion_dias: 2, activo: true},
  %{codigo: "T007", juego: "CS2", organizador: "ESL",
    pais: "México", participantes: 128, premio: 7500000, duracion_dias: 4, activo: true},
  %{codigo: "T008", juego: "Fortnite", organizador: "Epic",
    pais: "México", participantes: 150, premio: 4000000, duracion_dias: 3, activo: true},
  %{codigo: "T009", juego: "FIFA", organizador: "EA Sports",
    pais: "Argentina", participantes: 64, premio: 3500000, duracion_dias: 2, activo: false},
  %{codigo: "T010", juego: "CS2", organizador: "Riot",
    pais: "Colombia", participantes: 112, premio: 5500000, duracion_dias: 3, activo: true}
]

    IO.inspect(agrupar_torneos(torneos))
    IO.inspect(encontrar_torneo_mayor_premio(torneos))
    IO.inspect(ordenar_formato(torneos))
    IO.inspect(hay_premio_mayor?(torneos, "Colombia", 4000000))
    IO.inspect(clasificar_torneos(torneos))
    IO.inspect(encontrar_juegos_recurrentes(torneos))
    IO.inspect(todos_los_torneos_activos?(torneos, "Riot"))

  end

  def agrupar_torneos(lista)do
    lista
    |>Enum.group_by(fn t -> t.pais end)
    |>Enum.map(fn {pais, torneos} -> {pais, Enum.count(torneos)} end)
    |>Enum.sort_by(fn {_, cantidad} -> cantidad end, :desc)
  end

  def encontrar_torneo_mayor_premio(lista) do
    lista
    |>Enum.filter(fn t -> t.activo end)
    |>Enum.max_by(fn t -> t.premio end)
  end

  def ordenar_formato(lista) do
    lista
    |>Enum.filter(fn t -> t.activo end)
    |>Enum.map(fn t ->
      if t.duracion_dias == 1 do
        "Torneo #{t.codigo} - #{t.juego} (Duración: #{t.duracion_dias} días) Expres"
    else
        "Torneo #{t.codigo} - #{t.juego} (Duración: #{t.duracion_dias} días)"
      end
    end)
  end

  def hay_premio_mayor?(lista, pais, monto) do
   torneo =
    lista
    |>Enum.filter(fn t -> t.pais == pais and t.activo and t.premio > monto end)
    |>Enum.max_by(fn t -> t.premio end)
    {torneo.codigo, torneo.juego, torneo.premio}
  end

  def clasificar_torneos(lista)do
    categorizar = fn
      t when t.participantes < 100 -> :pequeño
      t when t.participantes >= 100 and t.participantes < 130 -> :mediano
      _-> :grande
      end

    lista
    |>Enum.group_by(fn t -> categorizar.(t) end)
    |>Enum.map(fn {categoria, torneos} -> {categoria, Enum.count(torneos)} end)
    |>Enum.sort_by(fn {_, cantidad} -> cantidad end, :desc)
  end


  def encontrar_juegos_recurrentes(lista) do
    lista
    |>Enum.group_by(fn t -> t.juego end)
    |>Enum.map(fn {juego, torneos} -> {juego, Enum.map(torneos, fn t -> t.participantes end)|>Enum.sum()} end)
    |>Enum.sort_by(fn {_, participantes} -> participantes end, :desc)
    |>Enum.take(3)
  end

  def todos_los_torneos_activos?(lista, organizador) do
    Enum.filter(lista, fn t -> t.organizador == organizador end)
    |>Enum.all?(fn t -> t.activo end)
  end
end
TorneoVideojuegos.main()
