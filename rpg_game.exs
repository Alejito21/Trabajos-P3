defmodule RPG do
  # ──────────────────────────────────────────────────────────────────────────────────────────
  # Datos iniciales de los enemigos, clases y armas predefinidos para el juego.
  # Son listas constantes.
  # ──────────────────────────────────────────────────────────────────────────────────────────

  #Lista de Maps con los datos de los enemigos disponibles en el juego.
  @enemigos_disponibles [
    %{nombre: "Goblin",     especie: "Bestia",  daño: 15},
    %{nombre: "Esqueleto",  especie: "No-Muerto", daño: 20},
    %{nombre: "Orco",       especie: "Bestia",  daño: 25},
    %{nombre: "Vampiro",    especie: "No-Muerto", daño: 30},
    %{nombre: "Troll",      especie: "Gigante", daño: 35},
    %{nombre: "Dragón",     especie: "Dragón",  daño: 40},
    %{nombre: "Bandido",    especie: "Humano",  daño: 18},
    %{nombre: "Lobo Alfa",  especie: "Bestia",  daño: 22}
  ]

  #Lista de las clases de personaje y las armas que pueden elegir los jugadores al crear su personaje.
  @clases_disponibles ["Guerrero", "Mago", "Arquero", "Paladín", "Asesino"]
  @armas_disponibles  ["Espada", "Bastón Mágico", "Arco", "Martillo Sagrado", "Daga"]

  # ─────────────────────────────────────────────
  # Punto de inicio del juego.
  # ─────────────────────────────────────────────

  def iniciar do
    limpiar_pantalla()
    mostrar_titulo()
    lista_personajes = []
    personaje = crear_personaje(lista_personajes)
    lista_personajes = [personaje | lista_personajes]

    IO.puts("\n╔══════════════════════════════════════╗")
    IO.puts("║   ¡Que comience la aventura!  ⚔️       ║")
    IO.puts("╚══════════════════════════════════════╝\n")
    :timer.sleep(1000)

    resultado = jugar(personaje, 0, lista_personajes)
    fin_del_juego(resultado, lista_personajes)
  end

  # ─────────────────────────────────────────────
  # Pantalla de título inicial
  # ─────────────────────────────────────────────

  defp mostrar_titulo do
    IO.puts("╔════════════════════════════════════════╗")
    IO.puts("║         ⚔️  ELIXIR RPG QUEST  ⚔️          ║")
    IO.puts("║      Aventura en el Reino de Elixia      ║")
    IO.puts("╚════════════════════════════════════════╝\n")
  end

  # ──────────────────────────────────────────────────────────────────────────────────────────
  # Función para crear el personaje del jugador, solicitando nombre, clase, vida y arma.
  # ──────────────────────────────────────────────────────────────────────────────────────────

  #Función que crear el personaje basado en los datos ingresados por el usuario, y mostrar la ficha del personaje creado.
  #Los datos se guardan en un Map.
  defp crear_personaje(lista_personajes) do
    IO.puts("════════════════════════════════════════")
    IO.puts("        CREACIÓN DE PERSONAJE")
    IO.puts("════════════════════════════════════════\n")

    nombre = leer_input("👤 Ingresa el nombre de tu personaje: ")

    IO.puts("\n📋 Clases disponibles:")
    @clases_disponibles |> Enum.with_index(1) |> Enum.each(fn {c, i} ->
      IO.puts("   #{i}. #{c}")
    end)
    clase_idx = leer_numero("   Elige tu clase (1-#{length(@clases_disponibles)}): ", 1, length(@clases_disponibles))
    clase = Enum.at(@clases_disponibles, clase_idx - 1)

    vida = leer_numero("\n❤️  Elige tus puntos de vida (50-150): ", 50, 150)

    IO.puts("\n⚔️  Armas disponibles:")
    @armas_disponibles |> Enum.with_index(1) |> Enum.each(fn {a, i} ->
      IO.puts("   #{i}. #{a}")
    end)
    arma_idx = leer_numero("   Elige tu arma (1-#{length(@armas_disponibles)}): ", 1, length(@armas_disponibles))
    arma = Enum.at(@armas_disponibles, arma_idx - 1)

    personaje = %{
      nombre:    nombre,
      clase:     clase,
      vida:      vida,
      vida_max:  vida,
      arma:      arma
    }

    IO.puts("\n✅ ¡Personaje creado exitosamente!")
    mostrar_ficha(personaje)
    :timer.sleep(800)

    _ = lista_personajes  # referenciamos para cumplir requisito de guardarlos en una lista
    personaje
  end

  defp mostrar_ficha(p) do
    IO.puts("\n┌─────────────────────────────┐")
    IO.puts("│        FICHA DEL HÉROE      │")
    IO.puts("├─────────────────────────────┤")
    IO.puts("│ Nombre : #{String.pad_trailing(p.nombre, 19)}│")
    IO.puts("│ Clase  : #{String.pad_trailing(p.clase,  19)}│")
    IO.puts("│ Vida   : #{String.pad_trailing("#{p.vida}/#{p.vida_max}", 19)}│")
    IO.puts("│ Arma   : #{String.pad_trailing(p.arma,   19)}│")
    IO.puts("└─────────────────────────────┘")
  end

  # ──────────────────────────────────────────────────────────────────────────────────────────
  # Bucle principal del juego: enfrentamientos contra enemigos hasta derrotar a 3 o morir
  # ──────────────────────────────────────────────────────────────────────────────────────────

  #Función jugar que devuelve la tupla al vencer a los tres enemigos requeridos.
  defp jugar(personaje, enemigos_derrotados, _lista_personajes) when enemigos_derrotados >= 3 do
    {:victoria, personaje}
  end

  #Función jugar que mide el progreso del jugador en base a las acciones tomadas en el combate.
  defp jugar(personaje, enemigos_derrotados, lista_personajes) do
    enemigo = generar_enemigo()

    IO.puts("\n\n════════════════════════════════════════")
    IO.puts("  ⚔️  ENCUENTRO #{enemigos_derrotados + 1} de 3")
    IO.puts("════════════════════════════════════════")
    IO.puts("🔴 ¡Apareció un #{enemigo.nombre} (#{enemigo.especie})!")
    IO.puts("   Daño de ataque: #{enemigo.daño}")
    :timer.sleep(800)

    case combate(personaje, enemigo) do
      {:victoria, personaje_actualizado} ->
        nuevos_derrotados = enemigos_derrotados + 1
        IO.puts("\n🏆 ¡Enemigos derrotados: #{nuevos_derrotados}/3!")
        personaje_curado = curar_personaje(personaje_actualizado)
        :timer.sleep(600)
        jugar(personaje_curado, nuevos_derrotados, lista_personajes)

      {:derrota, personaje_final} ->
        {:derrota, personaje_final}

      {:escape, personaje_actualizado} ->
        IO.puts("\n💨 Huiste... pero el peligro acecha.")
        :timer.sleep(600)
        jugar(personaje_actualizado, enemigos_derrotados, lista_personajes)
    end
  end

  # ─────────────────────────────────────────────
  # Sistema de combate
  # ─────────────────────────────────────────────

  #Función que permite al personaje enfretarse al enemigo.
  defp combate(personaje, enemigo) do
    vida_enemigo = 60 + :rand.uniform(40)   # enemigo tiene 60–100 de vida
    combate_turno(personaje, enemigo, vida_enemigo, false)
  end

  #Función que anuncia la vitoria del personaje al derrotar al enemigo.
  defp combate_turno(personaje, _enemigo, vida_enemigo, _defendiendo) when vida_enemigo <= 0 do
    IO.puts("\n💀 ¡#{personaje.nombre} derrotó al enemigo!")
    {:victoria, personaje}
  end

  #Función que muestra las acciones que puede realizar el personaje en su turno.
  defp combate_turno(personaje, enemigo, vida_enemigo, defendiendo) do
    mostrar_estado_combate(personaje, enemigo, vida_enemigo)

    IO.puts("\n¿Qué hace #{personaje.nombre}?")
    IO.puts("  1. ⚔️  Atacar")
    IO.puts("  2. 🛡️  Defender")
    IO.puts("  3. 💨 Escapar")

    accion = leer_numero("  Tu elección (1-3): ", 1, 3)

    case accion do
      #Atacar
      #Muestra como el personaje ataca al enemigo, el daño causado y la vida restante del enemigo. Luego, el enemigo contraataca.
      #Se actualiza la vida del enemigo y se verifica si ha sido derrotado. Si el enemigo sigue vivo, realiza su turno de ataque contra el personaje.
      1 ->
        daño_jugador = 15 + :rand.uniform(20)
        nueva_vida_enemigo = max(0, vida_enemigo - daño_jugador)
        IO.puts("\n⚔️  #{personaje.nombre} ataca con #{personaje.arma} y causa #{daño_jugador} de daño!")

        if nueva_vida_enemigo <= 0 do
          combate_turno(personaje, enemigo, nueva_vida_enemigo, false)
        else
          {personaje_tras_ataque, resultado} = turno_enemigo(personaje, enemigo, false)
          case resultado do
            :vivo -> combate_turno(personaje_tras_ataque, enemigo, nueva_vida_enemigo, false)
            :muerto -> {:derrota, personaje_tras_ataque}
          end
        end

      #Defender
      #El personaje se prepara para defender, lo que reduce el daño del próximo ataque enemigo a la mitad.
      #La vida el personaje se actualiza.
      2 ->
        IO.puts("\n🛡️  #{personaje.nombre} se prepara para defender...")
        {personaje_tras_defensa, resultado} = turno_enemigo(personaje, enemigo, true)
        case resultado do
          :vivo  -> combate_turno(personaje_tras_defensa, enemigo, vida_enemigo, false)
          :muerto -> {:derrota, personaje_tras_defensa}
        end

      #Escapar
      #El personaje escapar del combate.
      #Se encuentra con otro enemigo aleatorio, pero mantiene su vida actual.
      3 ->
        IO.puts("\n💨 #{personaje.nombre} decide escapar del combate...")
        {:escape, personaje}
    end
  end

  # ─────────────────────────────────────────────
  # Turno del enemigo
  # ─────────────────────────────────────────────

  #Función que simula el turno del enemigo, calculando el daño que inflige al personaje y actualizando su vida.
  defp turno_enemigo(personaje, enemigo, defendiendo) do
    reduccion = if defendiendo, do: 0.5, else: 1.0
    daño_real = round(enemigo.daño * reduccion)
    nueva_vida = personaje.vida - daño_real

    if defendiendo do
      IO.puts("🛡️  El #{enemigo.nombre} ataca pero tu defensa reduce el daño a #{daño_real}!")
    else
      IO.puts("💢 El #{enemigo.nombre} ataca y causa #{daño_real} de daño!")
    end

    personaje_actualizado = %{personaje | vida: max(0, nueva_vida)}

    if nueva_vida <= 0 do
      IO.puts("💀 #{personaje.nombre} ha caído en combate...")
      {personaje_actualizado, :muerto}
    else
      IO.puts("❤️  Vida restante: #{personaje_actualizado.vida}")
      {personaje_actualizado, :vivo}
    end
  end

  # ─────────────────────────────────────────────
  # Estado del combate
  # ─────────────────────────────────────────────

  #Muestra el estado actual del combate, incluyendo la vida del personaje y del enemigo.
  defp mostrar_estado_combate(personaje, enemigo, vida_enemigo) do
    IO.puts("\n────────────────────────────────────────")
    IO.puts("  👤 #{personaje.nombre} (#{personaje.clase})  ❤️  #{personaje.vida}/#{personaje.vida_max}")
    IO.puts("  👾 #{enemigo.nombre} (#{enemigo.especie})  ❤️  #{vida_enemigo}")
    IO.puts("────────────────────────────────────────")
  end

  # ─────────────────────────────────────────────
  # Generar encuentros aleatorios
  # ─────────────────────────────────────────────

  #Función que selecciona un enemigo aleatorio de la lista de enemigos disponibles para cada encuentro.
  defp generar_enemigo do
    Enum.random(@enemigos_disponibles)
  end

  # ─────────────────────────────────────────────
  # Curación del personaje.
  # ─────────────────────────────────────────────

  #Función que cura al personaje después de cada combate, restaurando un porcentaje de su vida máxima.
  defp curar_personaje(personaje) do
    curacion = round(personaje.vida_max * 0.4)
    nueva_vida = min(personaje.vida_max, personaje.vida + curacion)
    personaje_curado = %{personaje | vida: nueva_vida}

    IO.puts("\n💊 ¡Descansas tras el combate y recuperas #{curacion} de vida!")
    IO.puts("❤️  Vida actual: #{nueva_vida}/#{personaje.vida_max}")
    :timer.sleep(800)

    personaje_curado
  end

  # ─────────────────────────────────────────────
  # Mensaje final del juego: victoria o derrota
  # ─────────────────────────────────────────────

  defp fin_del_juego({:victoria, personaje}, lista_personajes) do
    limpiar_pantalla()
    IO.puts("\n╔════════════════════════════════════════╗")
    IO.puts("║         🏆  ¡VICTORIA ÉPICA!  🏆        ║")
    IO.puts("╚════════════════════════════════════════╝")
    IO.puts("\n🎉 ¡#{personaje.nombre} ha derrotado a 3 enemigos y salvó el reino!")
    mostrar_ficha(personaje)
    mostrar_lista_personajes(lista_personajes)
  end

  defp fin_del_juego({:derrota, personaje}, lista_personajes) do
    limpiar_pantalla()
    IO.puts("\n╔════════════════════════════════════════╗")
    IO.puts("║          💀  GAME OVER  💀              ║")
    IO.puts("╚════════════════════════════════════════╝")
    IO.puts("\n😔 #{personaje.nombre} fue derrotado. El reino queda en oscuridad...")
    mostrar_ficha(personaje)
    mostrar_lista_personajes(lista_personajes)
  end

  defp mostrar_lista_personajes(lista) do
    IO.puts("\n📜 Héroes registrados en este mundo:")
    lista |> Enum.with_index(1) |> Enum.each(fn {p, i} ->
      IO.puts("  #{i}. #{p.nombre} — #{p.clase} con #{p.arma}")
    end)
    IO.puts("")
  end

  # ─────────────────────────────────────────────
  # Helpers de entrada
  # ─────────────────────────────────────────────

  #Función que ingresa un valor de tipo String.
  defp leer_input(prompt) do
    IO.write(prompt)
    valor = IO.read(:line) |> String.trim()
    if valor == "" do
      IO.puts("⚠️  El campo no puede estar vacío.")
      leer_input(prompt)
    else
      valor
    end
  end

  #Función que ingresar un entero dentro de un rango específico.
  defp leer_numero(prompt, min, max) do
    IO.write(prompt)
    case IO.read(:line) |> String.trim() |> Integer.parse() do
      {n, ""} when n >= min and n <= max ->
        n
      _ ->
        IO.puts("⚠️  Ingresa un número entre #{min} y #{max}.")
        leer_numero(prompt, min, max)
    end
  end

  defp limpiar_pantalla do
    IO.write("\e[2J\e[H")
  end
end

# ─────────────────────────────────────────────
# Iniciar el juego
# ─────────────────────────────────────────────
RPG.iniciar()
