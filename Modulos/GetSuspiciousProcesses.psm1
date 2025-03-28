function Get-RunningProcesses {
    # Obtén todos los procesos en ejecución
    $processes = Get-Process

    # Muestra el nombre del proceso y su dirección (Ruta completa donde se ejecuta)
    foreach ($process in $processes) {
        try {
            $processPath = (Get-WmiObject Win32_Process -Filter "ProcessId = $($process.Id)").ExecutablePath
            if ($processPath) {
                Write-Host "Proceso: $($process.Name) - ID: $($process.Id) - Directorio: $($processPath)"
            }
            else {
                Write-Host "Proceso: $($process.Name) - ID: $($process.Id) - Directorio no disponible"
            }
        }
        catch {
            Write-Host "Error al obtener la dirección para el proceso: $($process.Name)"
        }
    }
}
Get-RunningProcesses