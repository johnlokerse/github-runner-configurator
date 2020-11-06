$baseUrl = "https://api.github.com"

function Get-GitHubAuthToken {
    param (
        [Parameter(Mandatory = $true)]
        [string] $GitHubUserName,
        [Parameter(Mandatory = $true)]
        [string] $PAT
    )

    $token = "$GitHubUserName" + ":" + "$PAT"
    return [System.Convert]::ToBase64String([char[]]$token)
}

function Get-ProjectRegistrationToken {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Owner,
        [Parameter(Mandatory = $true)]
        [string] $Repo,
        [Parameter(Mandatory = $true)]
        [string] $Base64AuthToken
    )

    $restMethodBody = @{
        Uri     = "$baseUrl/repos/$Owner/$Repo/actions/runners/registration-token"
        Method  = "POST"
        Headers = @{
            Authorization = "Basic $Base64AuthToken"
            Accept        = "application/vnd.github.v3+json"
        }
    }

    Invoke-RestMethod @restMethodBody
}

function Get-RunnerFiles {
    param (
        [Parameter(Mandatory = $true)]
        [string] $DownloadLocation
    )

    New-Item -Path $DownloadLocation -ItemType Directory -Name actions-runner
    Set-Location $DownloadLocation\actions-runner\
    
    Write-Host "Downloading GitHub Runner files..."
    Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.273.4/actions-runner-win-x64-2.273.4.zip -OutFile actions-runner-win-x64-2.273.4.zip
    Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.273.4.zip", "$PWD")
}

function Install-Runner {
    param (
        [Parameter(Mandatory = $true)]
        [Alias("Url")][string] $GitHubRepoUrl,
        [Parameter(Mandatory = $true)]
        [Alias("Token")][string] $RegistrationToken,
        [Parameter(Mandatory = $false)]
        [string] $Name,
        [Parameter(Mandatory = $false)]
        [string] $WorkDirLocation
    )

    if (-not $Name) {
        $Name = Get-Hostname
    }

    if (-not $WorkDirLocation) {
        $WorkDirLocation = Get-CurrentDirectory
    }

    if (!(Verify-Path -Path $WorkDirLocation)) {
        throw [System.ArgumentException] "Invalid work directory location"
    }
    
    .\config.cmd --unattended --url $GitHubRepoUrl --token $RegistrationToken --name $Name --work $WorkDirLocation
}

function Install-RunnerAsService {
    param (
        [Parameter(Mandatory = $true)]
        [Alias("Url")][string] $GitHubRepoUrl,
        [Parameter(Mandatory = $true)]
        [Alias("Token")][string] $RegistrationToken,
        [Parameter(Mandatory = $true)]
        [string] $LogonAccount,
        [Parameter(Mandatory = $true)]
        [string] $LogonPassword,
        [Parameter(Mandatory = $false)]
        [string] $Name,
        [Parameter(Mandatory = $false)]
        [string] $WorkDirLocation
    )

    if (-not $Name) {
        $Name = Get-Hostname
    }

    if (-not $WorkDirLocation) {
        $WorkDirLocation = Get-CurrentDirectory
    }

    if (!(Verify-Path -Path $WorkDirLocation)) {
        throw [System.ArgumentException] "Invalid work directory location"
    }

    .\config.cmd --unattended --url $GitHubRepoUrl --token $RegistrationToken --runasservice --windowslogonaccount $LogonAccount --windowslogonpassword $LogonPassword --name $Name --work $WorkDirLocation
}

function Remove-Runner {
    throw [System.NotImplementedException] "Remove runner has not been implemented yet!"    
}

#region Helpers
function Get-Hostname {
    return [System.Net.Dns]::GetHostname()
}

function Verify-Path {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Path
    )
    
    return Test-Path -Path $Path
}

function Get-CurrentDirectory {
    return (Get-Location).Path
}
#endregion Helpers

Export-ModuleMember Get-GitHubAuthToken
Export-ModuleMember Get-ProjectRegistrationToken
Export-ModuleMember Get-RunnerFiles
Export-ModuleMember Install-Runner
Export-ModuleMember Install-RunnerAsService
Export-ModuleMember Remove-Runner