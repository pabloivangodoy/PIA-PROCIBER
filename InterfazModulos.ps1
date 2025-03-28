# Activar el modo estricto
Set-StrictMode -Version Latest

# Definir la ruta de los módulos
$moduloPath = "$env:ProgramFiles\WindowsPowerShell\Modules\PIA\Modulos"

# Función para importar y ejecutar los módulos
function Ejecutar-Modulo {
    param (
        [string]$nombreModulo,
        [string]$folderPath
    )

    $moduloFile = "$moduloPath\$nombreModulo.psm1"

    if (Test-Path $moduloFile) {
        # Intentar importar el módulo
        try {
            Import-Module "$moduloPath\$nombreModulo.psm1" -Force -ErrorAction Stop
            Write-Host "Módulo $nombreModulo cargado correctamente." -ForegroundColor Green
        }
        catch {
            Write-Host "Error al cargar el módulo $nombreModulo $_" -ForegroundColor Red
            return
        }

        switch ($nombreModulo) {
            "GetHiddenFiles" {
                Write-Host "Ejecutando GetHiddenFiles en: $folderPath" -ForegroundColor Cyan
                try {
                    Get-HiddenFiles -FolderPath $folderPath
                }
                catch {
                    Write-Host "Error al ejecutar Get-HiddenFiles: $_" -ForegroundColor Red
                }
            }
            "GetSystemResourceUsage" {
                Write-Host "Ejecutando GetSystemResourceUsage..." -ForegroundColor Cyan
                try {
                    Get-SystemResourceUsage
                }
                catch {
                    Write-Host "Error al ejecutar Get-SystemResourceUsage: $_" -ForegroundColor Red
                }
            }
            "GetSuspiciousProcesses" {
                Write-Host "Ejecutando GetSuspiciousProcesses..." -ForegroundColor Cyan
                try {
                    Get-SuspiciousProcesses -FolderPath "C:\Windows\System32"
                }
                catch {
                    Write-Host "Error al ejecutar Get-SuspiciousProcesses: $_" -ForegroundColor Red
                }
            }
            default {
                Write-Host "Error: Módulo no encontrado." -ForegroundColor Red
            }
        }
    } else {
        Write-Host "Error: No se encontró el módulo $nombreModulo en $moduloPath" -ForegroundColor Red
    }
}

# Función para mostrar ayuda de un cmdlet
function Mostrar-Ayuda {
    $cmdlet = Read-Host "Ingresa el nombre del cmdlet para ver su ayuda"
    if ($cmdlet -match "^[a-zA-Z0-9-]+$") {
        try {
            Get-Help $cmdlet -Full
        }
        catch {
            Write-Host "Error: No se encontró ayuda para '$cmdlet'." -ForegroundColor Red
        }
    } else {
        Write-Host "Entrada no válida. Ingresa solo el nombre del cmdlet." -ForegroundColor Red
    }
}

# Menú interactivo
function Mostrar-Menu {
    do {
        Clear-Host
        Write-Host "===== MENÚ PRINCIPAL =====" -ForegroundColor Cyan
        Write-Host "1) Buscar archivos ocultos"
        Write-Host "2) Monitorear uso de recursos del sistema"
        Write-Host "3) Detectar procesos sospechosos"
        Write-Host "4) Obtener ayuda sobre un cmdlet"
        Write-Host "5) Salir"

        $seleccion = Read-Host "Selecciona una opción (1-5)"

        switch ($seleccion) {
            "1" {
                Write-Host "Opción 1 seleccionada: Buscar archivos ocultos" -ForegroundColor Yellow
                $folderPath = Read-Host "Ingresa la ruta de la carpeta donde deseas buscar archivos ocultos"
                if (Test-Path $folderPath) {
                    Ejecutar-Modulo -nombreModulo "GetHiddenFiles" -folderPath $folderPath
                } else {
                    Write-Host "Error: La carpeta ingresada no existe. Intenta nuevamente." -ForegroundColor Red
                }
            }
            "2" {
                Write-Host "Opción 2 seleccionada: Monitorear uso de recursos del sistema" -ForegroundColor Yellow
                Ejecutar-Modulo -nombreModulo "GetSystemResourceUsage"
            }
            "3" {
                Write-Host "Opción 3 seleccionada: Detectar procesos sospechosos" -ForegroundColor Yellow
                Ejecutar-Modulo -nombreModulo "GetSuspiciousProcesses"
            }
            "4" {
                Write-Host "Opción 4 seleccionada: Obtener ayuda sobre un cmdlet" -ForegroundColor Yellow
                Mostrar-Ayuda
            }
            "5" {
                Write-Host "Saliendo..." -ForegroundColor Green
                exit
            }
            default {
                Write-Host "Opción no válida. Intenta de nuevo." -ForegroundColor Red
            }
        }

        Start-Sleep -Seconds 10  # Reducido el tiempo de espera para depuración
    } while ($true)
}

# Iniciar el menú
Mostrar-Menu
