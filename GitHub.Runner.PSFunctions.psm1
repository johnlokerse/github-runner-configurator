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
    New-Item -Path D: -ItemType Directory -Name actions-runner
    Set-Location D:\actions-runner
    Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.273.4/actions-runner-win-x64-2.273.4.zip -OutFile actions-runner-win-x64-2.273.4.zip
    Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.273.4.zip", "$PWD")
}

function Install-Runner {
    [Parameter(Mandatory = $true)]
    [string] $GitHubRepoUrl
    [Parameter(Mandatory = $true)]
    [string] $RegistrationToken
    
    Invoke-Item -Path $PWD\config.cmd --url $GitHubRepoUrl --token $RegistrationToken
}