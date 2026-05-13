defmodule Estadio.Semaforo do
  use GenServer

  @max_aficionados 30

  # ──────────────────────────────────────────────
  # API pública
  # ──────────────────────────────────────────────

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  @doc "Intenta ingresar al estadio. Retorna :ok o {:error, :lleno}"
  def acquire(pid) do
    GenServer.call(pid, :acquire)
  end

  @doc "Sale del estadio. Retorna :ok o {:error, :vacio}"
  def release(pid) do
    GenServer.call(pid, :release)
  end

  @doc "Consulta el estado actual del estadio."
  def status(pid) do
    GenServer.call(pid, :status)
  end

  # ──────────────────────────────────────────────
  # Callbacks del GenServer
  # ──────────────────────────────────────────────

  @impl true
  def init(_opts) do
    state = %{
      aficionados: 0,
      max: @max_aficionados
    }
    {:ok, state}
  end

  @impl true
  def handle_call(:acquire, _from, %{aficionados: count, max: max} = state)
      when count < max do

    # --- SIMULACIÓN DE TIEMPO DE ESPERA ---
    IO.puts("⏳ Procesando ingreso en el torniquete...")
    Process.sleep(800) # Espera 0.8 segundos

    nuevo_estado = %{state | aficionados: count + 1}
    IO.puts("✅ Ingreso permitido — Aficionados: #{nuevo_estado.aficionados}/#{max}")
    {:reply, :ok, nuevo_estado}
  end

  def handle_call(:acquire, _from, %{max: max} = state) do
    IO.puts("🚫 Estadio lleno (#{max}/#{max}) — Ingreso denegado")
    {:reply, {:error, :lleno}, state}
  end

  @impl true
  def handle_call(:release, _from, %{aficionados: count} = state)
      when count > 0 do

    # --- SIMULACIÓN DE TIEMPO DE ESPERA ---
    IO.puts("⏳ Procesando salida...")
    Process.sleep(500) # Espera 0.5 segundos

    nuevo_estado = %{state | aficionados: count - 1}
    IO.puts("👋 Salida registrada — Aficionados: #{nuevo_estado.aficionados}/#{state.max}")
    {:reply, :ok, nuevo_estado}
  end

  def handle_call(:release, _from, state) do
    IO.puts("⚠️  No hay aficionados registrados para retirar")
    {:reply, {:error, :vacio}, state}
  end

  @impl true
  def handle_call(:status, _from, %{aficionados: count, max: max} = state) do
    info = %{
      aficionados: count,
      disponibles: max - count,
      max: max,
      porcentaje_ocupacion: Float.round(count / max * 100, 1)
    }
    {:reply, info, state}
  end


  def main do
    {:ok, pid} = Estadio.Semaforo.start_link(name: :estadio_principal)

    IO.puts("--- INICIANDO SIMULACIÓN CON TIEMPOS DE ESPERA ---")

    # Intentar varios ingresos
    Enum.each(1..5, fn _ -> Estadio.Semaforo.acquire(pid) end)

    # Consultar estado
    IO.inspect(Estadio.Semaforo.status(pid), label: "Estado actual")

    # Simular una salida
    Estadio.Semaforo.release(pid)
    Estadio.Semaforo.release(pid)
    Estadio.Semaforo.release(pid)



    # Llenar el estadio (esto tardará un poco por el sleep)
    IO.puts("\n--- LLENANDO EL ESTADIO RÁPIDAMENTE ---")
    Enum.each(1..30, fn _ -> Estadio.Semaforo.acquire(pid) end)

    Estadio.Semaforo.release(pid)
    Estadio.Semaforo.release(pid)


    # Intento final cuando ya está lleno
    Estadio.Semaforo.acquire(pid)

    IO.puts("--- SIMULACIÓN FINALIZADA ---")
  end
end

Estadio.Semaforo.main()
