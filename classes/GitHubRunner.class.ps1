class GitHubBase {
    [string] $UserName
    [string] $PersonalAccessToken
    [string] $RepositoryUrl
    [string] $BaseUrl = "https://api.github.com"

    [System.Convert] GetGitHubAuthToken ([string] $UserName, [string] $PersonalAccessToken) {
        $token = "$UserName" + ":" + "$PersonalAccessToken"
        return [System.Convert]::ToBase64String([char[]] $token)
    }
}

class GitHubRunner : GitHubBase {
    GitHubRunner($UserName, $PersonalAccessToken, $RepositoryUrl) : base($UserName, $PersonalAccessToken, $RepositoryUrl) {

    }

    [void] GetRunnerFiles([string] $DownloadLocation) {
        New-Item -Path $DownloadLocation -ItemType Directory -Name actions-runner
        if (Test-Path -Path $DownloadLocation) {
            Set-Location $DownloadLocation\actions-runner\
        }

        Write-Host "Downloading GitHub Runner files..."
        Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.273.4/actions-runner-win-x64-2.273.4.zip -OutFile actions-runner-win-x64-2.273.4.zip
        Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.273.4.zip", "$PWD")
    }
}