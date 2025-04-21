defmodule Sala do
  def inicio(nombreSala) do
    IO.puts("[+] Sala #{nombreSala} creada.")
    ciclo(nombreSala, [])
  end

  defp ciclo(nombre_sala, usuarios) do
    receive do
      {:unirse, nombreUsuario, pid_usuario} ->
        IO.puts("#{nombreUsuario} se ha unido a la sala #{nombre_sala}.")
        Enum.each(usuarios, fn {_nombre, pid} ->
          send(pid, {:chat, "#{nombreUsuario} se ha unido a la sala #{nombre_sala}."})
        end)
        ciclo(nombre_sala, [{nombreUsuario, pid_usuario} | usuarios])

      {:mensaje, nombreUsuario, mensaje} ->
        Enum.each(usuarios, fn {_nombre, pid} ->
          send(pid, {:chat, "[#{nombre_sala}] #{nombreUsuario}: #{mensaje}"})
        end)
        ciclo(nombre_sala, usuarios)
    end
  end
end
