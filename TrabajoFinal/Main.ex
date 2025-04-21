defmodule main do
    def correr do
      pid_servidor = spawn(Servidor, :inicio, [])

      spawn(fn -> Cliente.iniciar("andres", pid_servidor) end)
      spawn(fn -> Cliente.iniciar("juliana", pid_servidor) end)
    end
end
