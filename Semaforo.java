import java.util.concurrent.Semaphore;
import java.util.concurrent.TimeUnit;

/**
 * Demostración de Semaphore en Java para manejo de hilos.
 *
 * Un Semaphore controla cuántos hilos pueden acceder a un recurso
 * compartido simultáneamente usando un contador de permisos.
 *
 *   acquire() → decrementa el contador (bloquea si llega a 0)
 *   release() → incrementa el contador (despierta hilos en espera)
 */
public class Semaforo{

    // ─────────────────────────────────────────────
    // EJEMPLO 1: Acceso concurrente limitado
    // Simula 8 hilos compitiendo por 3 permisos
    // ─────────────────────────────────────────────
    static void ejemplo1_AccesoConcurrente() throws InterruptedException {
        final int MAX_CONCURRENTES = 3;
        final int TOTAL_HILOS = 8;

        Semaphore semaforo = new Semaphore(MAX_CONCURRENTES);

        System.out.println("=== EJEMPLO 1: Acceso concurrente limitado ===");
        System.out.println("Hilos: " + TOTAL_HILOS + " | Permisos: " + MAX_CONCURRENTES);
        System.out.println("─".repeat(50));

        Thread[] hilos = new Thread[TOTAL_HILOS];

        for (int i = 0; i < TOTAL_HILOS; i++) {
            final int id = i + 1;
            hilos[i] = new Thread(() -> {
                try {
                    System.out.printf("[Hilo-%d] Esperando permiso... (disponibles: %d)%n",
                            id, semaforo.availablePermits());

                    semaforo.acquire();  // Bloquea si no hay permisos libres

                    System.out.printf("[Hilo-%d] ✓ Permiso obtenido → ejecutando tarea%n", id);
                    simularTrabajo(500 + (int)(Math.random() * 1000));

                    System.out.printf("[Hilo-%d] ✗ Tarea completada → liberando permiso%n", id);

                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                } finally {
                    semaforo.release();  // Siempre en finally para garantizar liberación
                }
            });
            hilos[i].setName("Hilo-" + id);
        }

        for (Thread h : hilos) h.start();
        for (Thread h : hilos) h.join();

        System.out.println("─".repeat(50));
        System.out.println("Todos los hilos completados.\n");
    }

    // ─────────────────────────────────────────────
    // EJEMPLO 2: Pool de conexiones a base de datos
    // Patrón real muy común con Semaphore
    // ─────────────────────────────────────────────
    static class PoolConexiones {
        private final Semaphore semaforo;
        private final String[] conexiones;
        private final boolean[] disponible;
        private final int tamano;

        PoolConexiones(int tamano) {
            this.tamano = tamano;
            this.semaforo = new Semaphore(tamano, true); // true = orden justo (FIFO)
            this.conexiones = new String[tamano];
            this.disponible = new boolean[tamano];

            for (int i = 0; i < tamano; i++) {
                conexiones[i] = "Conexión-DB-" + (i + 1);
                disponible[i] = true;
            }
        }

        // Obtiene una conexión (bloquea si todas están ocupadas)
        String obtenerConexion() throws InterruptedException {
            semaforo.acquire();
            return reservarConexion();
        }

        // Intenta obtener conexión con tiempo límite
        String obtenerConexionConTimeout(long segundos) throws InterruptedException {
            if (!semaforo.tryAcquire(segundos, TimeUnit.SECONDS)) {
                return null; // No se pudo obtener en tiempo
            }
            return reservarConexion();
        }

        // Libera la conexión de regreso al pool
        void liberarConexion(String conexion) {
            devolverConexion(conexion);
            semaforo.release();
        }

        int permisosDisponibles() {
            return semaforo.availablePermits();
        }

        private synchronized String reservarConexion() {
            for (int i = 0; i < tamano; i++) {
                if (disponible[i]) {
                    disponible[i] = false;
                    return conexiones[i];
                }
            }
            return null;
        }

        private synchronized void devolverConexion(String conn) {
            for (int i = 0; i < tamano; i++) {
                if (conexiones[i].equals(conn)) {
                    disponible[i] = true;
                    return;
                }
            }
        }
    }

    static void ejemplo2_PoolConexiones() throws InterruptedException {
        final int POOL_SIZE = 2;
        final int CLIENTES = 5;

        PoolConexiones pool = new PoolConexiones(POOL_SIZE);

        System.out.println("=== EJEMPLO 2: Pool de conexiones a base de datos ===");
        System.out.printf("Pool: %d conexiones | Clientes: %d%n", POOL_SIZE, CLIENTES);
        System.out.println("─".repeat(50));

        Thread[] clientes = new Thread[CLIENTES];

        for (int i = 0; i < CLIENTES; i++) {
            final int id = i + 1;
            clientes[i] = new Thread(() -> {
                String conexion = null;
                try {
                    System.out.printf("[Cliente-%d] Solicitando conexión... (libres: %d)%n",
                            id, pool.permisosDisponibles());

                    // Intentar con timeout de 5 segundos
                    conexion = pool.obtenerConexionConTimeout(5);

                    if (conexion == null) {
                        System.out.printf("[Cliente-%d] ✗ Timeout: no se obtuvo conexión%n", id);
                        return;
                    }

                    System.out.printf("[Cliente-%d] ✓ Usando %s%n", id, conexion);
                    simularTrabajo(800 + (int)(Math.random() * 700));

                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                } finally {
                    if (conexion != null) {
                        pool.liberarConexion(conexion);
                        System.out.printf("[Cliente-%d] Conexión devuelta al pool (libres: %d)%n",
                                id, pool.permisosDisponibles());
                    }
                }
            });
        }

        for (Thread c : clientes) c.start();
        for (Thread c : clientes) c.join();

        System.out.println("─".repeat(50));
        System.out.println("Pool finalizado. Conexiones libres: " + pool.permisosDisponibles() + "\n");
    }

    // ─────────────────────────────────────────────
    // EJEMPLO 3: Semáforo binario (Mutex)
    // Equivalente a un lock para sección crítica
    // ─────────────────────────────────────────────
    static int contadorCompartido = 0;
    static final Semaphore mutex = new Semaphore(1); // 1 permiso = mutex

    static void ejemplo3_Mutex() throws InterruptedException {
        final int HILOS = 10;
        final int INCREMENTOS_POR_HILO = 1000;

        System.out.println("=== EJEMPLO 3: Semáforo binario como Mutex ===");
        System.out.println("Incrementando contador compartido con " + HILOS + " hilos");
        System.out.println("─".repeat(50));

        contadorCompartido = 0;
        Thread[] hilos = new Thread[HILOS];

        for (int i = 0; i < HILOS; i++) {
            hilos[i] = new Thread(() -> {
                for (int j = 0; j < INCREMENTOS_POR_HILO; j++) {
                    try {
                        mutex.acquire();        // Sección crítica: inicio
                        contadorCompartido++;   // Operación no atómica protegida
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
                    } finally {
                        mutex.release();        // Sección crítica: fin
                    }
                }
            });
        }

        for (Thread h : hilos) h.start();
        for (Thread h : hilos) h.join();

        int esperado = HILOS * INCREMENTOS_POR_HILO;
        System.out.printf("Esperado: %d | Obtenido: %d | %s%n",
                esperado, contadorCompartido,
                contadorCompartido == esperado ? "✓ CORRECTO" : "✗ CONDICIÓN DE CARRERA");
        System.out.println("─".repeat(50));
    }

    // Utilidad: simula trabajo con sleep
    static void simularTrabajo(int ms) throws InterruptedException {
        TimeUnit.MILLISECONDS.sleep(ms);
    }

    public static void main(String[] args) throws InterruptedException {
        ejemplo1_AccesoConcurrente();
        ejemplo2_PoolConexiones();
        ejemplo3_Mutex();
    }
}