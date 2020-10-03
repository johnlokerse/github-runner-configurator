# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Set Chocolatey Alias
Set-Alias -Name choco -Value (Get-Command choco.exe).Source

# Install Function
function Install-ChocolateyPackage {
    param (
        [Parameter(Mandatory = $true)]
        [string] $PackageName,
        [string] $Version
    )

    Write-Host "Installing package $PackageName@$(-not $Version ? 'latest' : $Version)"
    if (-not $Version) {
        choco upgrade $PackageName --yes
    }
    else {
        choco upgrade $PackageName --version $Version --yes
    }
}

# Software
Install-ChocolateyPackage -PackageName microsoft-edge
Install-ChocolateyPackage -PackageName visualstudio2019enterprise
Install-ChocolateyPackage -PackageName visualstudio2019buildtools
Install-ChocolateyPackage -PackageName visualstudio2019-workload-netcorebuildtools
Install-ChocolateyPackage -PackageName netfx-4.7.2-devpack
Install-ChocolateyPackage -PackageName netfx-4.8-devpack
Install-ChocolateyPackage -PackageName dotnetcore-sdk --version 3.0.100
Install-ChocolateyPackage -PackageName dotnetcore-sdk
Install-ChocolateyPackage -PackageName dotnetcore-runtime --version 3.0.0
Install-ChocolateyPackage -PackageName dotnetcore-runtime 
Install-ChocolateyPackage -PackageName nodejs-lts.install
Install-ChocolateyPackage -PackageName nodejs-lts
Install-ChocolateyPackage -PackageName python2
Install-ChocolateyPackage -PackageName python3
Install-ChocolateyPackage -PackageName javaruntime
Install-ChocolateyPackage -PackageName azurecli
Install-ChocolateyPackage -PackageName az.powershell
Install-ChocolateyPackage -PackageName curl