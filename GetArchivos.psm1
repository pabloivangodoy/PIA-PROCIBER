function Get-HiddenFiles {
    param (
        [string]$FolderPath = "C:\Users\Public"  # Establecer una ruta por defecto si no se proporciona
    )

    if (-not (Test-Path $FolderPath)) {
        Write-Host "Error: La ruta '$FolderPath' no existe o no es válida." -ForegroundColor Red
        return
    }

    Get-ChildItem -Path $FolderPath -Hidden -ErrorAction SilentlyContinue
}

Export-ModuleMember -Function Get-HiddenFiles
