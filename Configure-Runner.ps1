Import-Module -Force .\GitHub.Runner.PSFunctions.psm1

param (
    [Parameter(Mandatory = $true)]
    [Alias("Username")][string] $GitHubUsername,
    [Parameter(Mandatory = $true)]
    [string] $PAT,
    [Parameter(Mandatory = $true)]
    [Alias("repo")][string] $GitHubRepoUrl
)

function Get-RepoName {
    [array] $splittedUrl = ($GitHubRepoUrl -Split "/")
    return $splittedUrl[$splittedUrl.Count - 1]
}

function Get-Owner {
    [array] $splittedUrl = ($GitHubRepoUrl -Split "/")
    return $splittedUrl[$splittedUrl.Count - 2]
}

[string] $authToken = Get-GitHubAuthToken -GitHubUserName $GitHubUserName -PAT $PAT
if (-not $authToken -or $authToken -eq "Og==") {
    Write-Error -Message "'$authToken' is invalid" -ErrorAction Stop
}

Write-Host "Downloading GitHub Runner files..."
Get-RunnerFiles
if (Test-Path -Path $PWD\*.cmd) {
    [string] $registrationToken = (Get-ProjectRegistrationToken -Owner Get-Owner -Repo Get-RepoName -Base64AuthToken $authToken).token
    Write-Host "Installing GitHub runner in $GitHubRepoUrl"
    Install-Runner -GitHubRepoUrl $GitHubRepoUrl -RegistrationToken $registrationToken
}
