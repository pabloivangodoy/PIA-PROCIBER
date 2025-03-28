function Get-HiddenFiles {
    param(
        [string]$FolderPath
    )

    if (!(Test-Path $FolderPath)) {
        Write-Host "La carpeta no existe."
        return
    }

    Get-ChildItem -Path $FolderPath -Hidden -File | Select-Object FullName, LastWriteTime
}