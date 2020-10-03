function Get-RunnerFiles {
    New-Item -ItemType Directory -Value actions-runner
    Set-Location actions-runner
    Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.273.4/actions-runner-win-x64-2.273.4.zip -OutFile actions-runner-win-x64-2.273.4.zip
    Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.273.4.zip", "$PWD")
}

Function Get-GitHubAuthToken {
    $token = "johnlokerse:-"
    return [System.Convert]::ToBase64String([char[]]$token)
}

Function Get-RegistrationToken {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Owner,
        [Parameter(Mandatory = $true)]
        [string] $Repo
    )


    $info = @{
        Uri     = "https://api.github.com/repos/$Owner/$Repo/actions/runners/registration-token"
        Method  = "POST"
        Headers = @{
            Authorization = "Basic $(Get-GitHubAuthToken)"
            Accept        = "application/vnd.github.v3+json"
        }
    }

    Invoke-RestMethod @info
}