@'
go build

if ($LASTEXITCODE -eq 0) {
    if (Test-Path .\.env) {
        $d = Get-Content .\.env -Raw
        if (-not $d -or $d.Trim().Length -lt 1) {
            $d = $env:USERPROFILE | Join-Path -ChildPath "tools\bin"
        }
        $d = [System.Environment]::ExpandEnvironmentVariables($d)
        if (-not (Test-Path $d -PathType Container)) {
            New-Item -Path $d -ItemType Directory
        }
        $m = (Get-Content "go.mod" | Select-Object -First 1) -replace "^module "
        $n = "{0}.exe" -f ($m -split "/" | Select-Object -Last 1)
        if (Test-Path $n) {
            Get-Item $n | Copy-Item -Destination $d -Force -ErrorAction Stop
            "COPIED {0} to: {1}" -f $n, $d | Write-Host -ForegroundColor Blue
        }
        else {
            "{0} not found!" -f $n | Write-Host -ForegroundColor Magenta
        }
    }
    else {
        ".env not found!" | Write-Host -ForegroundColor Magenta
    }
}
else {
    "Failed to build. Nothing was copied." | Write-Host -ForegroundColor Magenta
}
'@ | Out-File -Path "build.ps1" -Force
New-Item -Path ".env" -ItemType File -ErrorAction SilentlyContinue

$gi = ".gitignore"
$lines = @("*.env", "*.exe")
if (Test-Path $gi) {
    $lines | ForEach-Object {
        $p = $_
        if (-not (Select-String -Path $gi -Pattern $p -SimpleMatch)) {
            Write-Output $p | Out-File -FilePath $gi -Append
        }
    }
}
else {
    $lines | Out-File -FilePath $gi
}