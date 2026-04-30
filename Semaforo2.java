import java.util.concurrent.Semaphore;

class Semaforo2 {

    // Semáforo con 2 permisos (máximo 2 hilos al mismo tiempo)
    static Semaphore semaforo = new Semaphore(2);

    public static void main(String[] args) {

        for (int i = 1; i <= 5; i++) {
            int id = i;

            new Thread(() -> {
                try {
                    System.out.println("Hilo " + id + " quiere entrar");

                    semaforo.acquire(); // 🔴 Pide permiso

                    System.out.println("Hilo " + id + " está dentro");

                    Thread.sleep(2000); // Simula trabajo

                    System.out.println("Hilo " + id + " sale");

                    semaforo.release(); // 🟢 Libera permiso

                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }).start();
        }
    }
}