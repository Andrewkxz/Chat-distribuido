defmodule Servidor do
  def inicio do
    chats = %{
      usuarios: %{},
      salas: %{},
    }

    ciclo(chats)
  end

  def ciclo(chats) do
    receive do
      {:conectado, nombreUsuario, pid} ->
        IO.puts("[+] #{nombreUsuario} se ha conectado.")
        usuarios_nuevos = Map.put(chats.usuarios, nombreUsuario, pid)
        ciclo(%{chats | usuarios: usuarios_nuevos})

      {:desconectado, nombreUsuario} ->
        IO.puts("[+] #{nombreUsuario} se ha desconectado.")
        usuarios_nuevos = Map.delete(chats.usuarios, nombreUsuario)
        ciclo(%{chats | usuarios: usuarios_nuevos})

      {:crear_sala, nombreSala, pid_cliente} ->
        if Map.has_key?(chats.salas, nombreSala) do
          send(pid_cliente, {:error, "La sala ya existe."})
      else
        pid_sala = spawn(Sala, :inicio, [nombreSala])
        salas_nuevas = Map.put(chats.salas, nombreSala, pid_sala)
        send(pid_cliente, {:sala_creada, nombreSala})
        ciclo(%{chats | salas: salas_nuevas})
      end
      ciclo(chats)

      {:unirse_sala, nombreUsuario, nombreSala} ->
        case Map.get(chats.salas, nombreSala) do
          nil ->
            send(Map.get(chats.usuarios, nombreUsuario), {:error, "La sala no existe."})
          sala_pid ->
            send(sala_pid, {:unirse, nombreUsuario, Map.get(chats.usuarios, nombreUsuario)})
      end
      ciclo(chats)

      {:mensaje_sala, nombreSala, nombreUsuario, mensaje} ->
        case Map.get(chats.salas, nombreSala) do
          nil ->
            send(Map.get(chats.usuarios, nombreUsuario), {:error, "La sala no existe."})
          sala_pid ->
            send(sala_pid, {:mensaje, nombreUsuario, mensaje})
      end
      ciclo(chats)
    end
  end
end
