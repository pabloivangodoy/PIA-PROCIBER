# Muestra el uso de CPU
$cpuUsage = Get-Counter '\Processor(_Total)\% Processor Time'
$cpuUsageFormatted = $cpuUsage.CounterSamples.CookedValue
Write-Host "Uso de CPU: $($cpuUsageFormatted)%"

# Muestra el uso de memoria
$memoryUsage = Get-WmiObject -Class Win32_OperatingSystem
$totalMemory = [math]::round($memoryUsage.TotalVisibleMemorySize / 1MB, 2)
$freeMemory = [math]::round($memoryUsage.FreePhysicalMemory / 1MB, 2)
$usedMemory = [math]::round($totalMemory - $freeMemory, 2)
Write-Host "Memoria total: $($totalMemory) MB"
Write-Host "Memoria libre: $($freeMemory) MB"
Write-Host "Memoria utilizada: $($usedMemory) MB"

# Muestra el uso de disco
$diskUsage = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
foreach ($disk in $diskUsage) {
    $diskSize = [math]::round($disk.Size / 1GB, 2)
    $diskFree = [math]::round($disk.FreeSpace / 1GB, 2)
    $diskUsed = [math]::round($diskSize - $diskFree, 2)
    Write-Host "Disco: $($disk.DeviceID) - Total: $($diskSize) GB, Usado: $($diskUsed) GB, Libre: $($diskFree) GB"
}

# Muestra el uso de la red
$networkUsage = Get-Counter '\Network Interface(*)\Bytes Total/sec'
foreach ($network in $networkUsage.CounterSamples) {
    Write-Host "Interfaz de red: $($network.InstanceName) - Uso: $($network.CookedValue) bytes/sec"
}
# Muestra el uso de CPU
try {
    $cpuUsage = Get-Counter '\Processor(_Total)\% Processor Time'
    $cpuUsageFormatted = $cpuUsage.CounterSamples.CookedValue
    Write-Host "Uso de CPU: $($cpuUsageFormatted)%" -ForegroundColor Cyan
} catch {
    Write-Host "No se pudo obtener el uso de CPU." -ForegroundColor Red
}

# Muestra el uso de memoria
try {
    $memoryUsage = Get-CimInstance -ClassName Win32_OperatingSystem
    $totalMemory = [math]::round($memoryUsage.TotalVisibleMemorySize / 1MB, 2)
    $freeMemory = [math]::round($memoryUsage.FreePhysicalMemory / 1MB, 2)
    $usedMemory = [math]::round($totalMemory - $freeMemory, 2)
    Write-Host "Memoria total: $($totalMemory) MB" -ForegroundColor Cyan
    Write-Host "Memoria libre: $($freeMemory) MB" -ForegroundColor Cyan
    Write-Host "Memoria utilizada: $($usedMemory) MB" -ForegroundColor Cyan
} catch {
    Write-Host "No se pudo obtener el uso de memoria." -ForegroundColor Red
}

# Muestra el uso de disco
try {
    $diskUsage = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
    foreach ($disk in $diskUsage) {
        if ($disk.Size -and $disk.FreeSpace) {
            $diskSize = [math]::round($disk.Size / 1GB, 2)
            $diskFree = [math]::round($disk.FreeSpace / 1GB, 2)
            $diskUsed = [math]::round($diskSize - $diskFree, 2)
            Write-Host "Disco: $($disk.DeviceID) - Total: $($diskSize) GB, Usado: $($diskUsed) GB, Libre: $($diskFree) GB" -ForegroundColor Cyan
        } else {
            Write-Host "No se pudo obtener informaci n completa del disco $($disk.DeviceID)." -ForegroundColor Red
        }
    }
} catch {
    Write-Host "No se pudo obtener el uso de disco." -ForegroundColor Red
}

# Muestra el uso de la red
try {
    $networkUsage = Get-Counter '\Network Interface(*)\Bytes Total/sec'
    foreach ($network in $networkUsage.CounterSamples) {
        Write-Host "Interfaz de red: $($network.InstanceName) - Uso: $($network.CookedValue) bytes/sec" -ForegroundColor Cyan
    }
} catch {
    Write-Host "No se pudo obtener el uso de la red." -ForegroundColor Red
}
