function Get-SuspiciousProcesses {
    # Lista procesos con CPU > 10 o nombre sospechoso
    $procesos = Get-Process | Where-Object {
        ($_.CPU -gt 10) -or
        ($_.ProcessName -match "powershell|cmd|mimikatz|psexec")
    }
    if ($procesos) {
        $procesos | Format-Table Id, ProcessName, CPU -AutoSize | Out-String
    } else {
        "No se encontraron procesos sospechosos."
    }
}

Export-ModuleMember -Function Get-SuspiciousProcesses
