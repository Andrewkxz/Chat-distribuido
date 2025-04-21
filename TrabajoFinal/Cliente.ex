defmodule Cliente do
  def iniciar(nombreUsuario, pid_servidor) do
    send(pid_servidor, {:contectado, nombreUsuario, self()})
    ciclo(nombreUsuario, pid_servidor)
  end

  defp ciclo(nombreUsuario, pid_servidor) do
    receive do
      {:chat, mensaje} ->
        IO.puts(mensaje)

      {:error, mensaje} ->
        IO.puts("Error: #{mensaje}")
      _-> :ok
    end
    ciclo(nombreUsuario, pid_servidor)
  end
end
