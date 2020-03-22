if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

function Check-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# -----------------------------------------------------------------------------
$computerName = Read-Host 'Enter New Computer Name'
Write-Host "Renaming this computer to: " $computerName  -ForegroundColor Yellow
Rename-Computer -NewName $computerName
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Disable Sleep on AC Power..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Powercfg /Change monitor-timeout-ac 20
Powercfg /Change standby-timeout-ac 0
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Add 'This PC' Desktop Icon..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$thisPCIconRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
$thisPCRegValname = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" 
$item = Get-ItemProperty -Path $thisPCIconRegPath -Name $thisPCRegValname -ErrorAction SilentlyContinue 
if ($item) { 
    Set-ItemProperty  -Path $thisPCIconRegPath -name $thisPCRegValname -Value 0  
}
else { 
    New-ItemProperty -Path $thisPCIconRegPath -Name $thisPCRegValname -Value 0 -PropertyType DWORD | Out-Null  
}


# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Removing Edge Desktop Icon..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$edgeLink = $env:USERPROFILE + "\Desktop\Microsoft Edge.lnk"
Remove-Item $edgeLink

# -----------------------------------------------------------------------------
# To list all appx packages:
# Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName
Write-Host "Removing UWP Rubbish..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$uwpRubbishApps = @(
    "Microsoft.Messaging",
    "king.com.CandyCrushSaga",
    "Microsoft.BingNews",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.People",
    "Microsoft.Print3D",
    "Microsoft.ZuneMusic",
    "Microsoft.SkypeApp",
    "Microsoft.Print3D",
    "Microsoft.MicrosoftEdge",
    "Microsoft.ZuneVideo",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.YourPhone",
    "Microsoft.MicrosoftOfficeHub",
    "Fitbit.FitbitCoach",
    "4DF9E0F8.Netflix")

foreach ($uwp in $uwpRubbishApps) {
    Get-AppxPackage -Name $uwp | Remove-AppxPackage
}

if (Check-Command -cmdname 'choco') {
    Write-Host "Choco is already installed, skip installation."
}
else {
    Write-Host ""
    Write-Host "Installing Chocolate for Windows..." -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Write-Host ""
Write-Host "Installing Applications..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "[WARN] Ma de in China: some software like Google Chrome require the true Internet first" -ForegroundColor Yellow


$appsToInstall = @(
    "freedownloadmanager",
    "chrome",
    "firefox",
    "git",
    "python2",
    "python3",
    "vscode",
    "adobereader",
    "typora",
    "simple-sticky-notes",
    "microsoft-windows-terminal",
    "dbeaver",
    "powertoys",
    "vscode-python",
    "vscode-golang",
    "vscode-java",
    "vscode-prettier",
    "drawio",
    "golang",
    "firacode",
    "bitwarden",
    "everything",
    "wox",
    "wechat",
    "tim",
    "telegram",
    "shadowsocksr-windows",
    "aria2",
    "gimp",
    "ffmpeg",
    "yarn",
    "recuva",
    "potplayer")

foreach ($app in $appsToInstall) {
    Write-Host "------------------------------------" -ForegroundColor Yellow
    Write-Host "Installing " $app -ForegroundColor Green
    choco install -v --proxy=127.0.0.1:1080 $app -y
}

Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "Setup is done, restart is needed, press [ENTER] to restart computer."
Restart-Computer
