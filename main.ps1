@'
$d = $args[0]
if ($d.length -lt 1) {
    Write-Host "Specify directory to copy executable."
}
else {
    go build -o $d

    if ($LASTEXITCODE -eq 0) {
        "[FINISHED] Executable was built on {0}" -f $d | Write-Host -ForegroundColor Blue
    }
    else {
        "Failed to build. Nothing was copied." | Write-Host -ForegroundColor Magenta
    }
}
'@ | Out-File -Path "build.ps1" -Force
