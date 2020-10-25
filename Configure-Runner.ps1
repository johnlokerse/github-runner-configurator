Import-Module -Force .\GitHub.Runner.PSFunctions.psm1

param (
    [Parameter(Mandatory = $true)]
    [string] $GitHubUserName,
    [Parameter(Mandatory = $true)]
    [string] $PAT,
    [Parameter(Mandatory = $true)]
    [string] $GitHubRepoUrl
)

[string] $authToken = Get-GitHubAuthToken -GitHubUserName $GitHubUserName -PAT $PAT
if (-not $authToken -or $authToken -eq "Og==") {
    Write-Error -Message "'$authToken' is invalid" -ErrorAction Stop
}

Write-Host "Downloading GitHub Runner files..."
Get-RunnerFiles
if (Test-Path -Path $PWD\*.cmd) {
    [string] $registrationToken = (Get-ProjectRegistrationToken -Owner johnlokerse -Repo github-runner-configurator -Base64AuthToken $authToken).token
    Write-Host "Installing GitHub runner in $GitHubRepoUrl"
    Install-Runner -GitHubRepoUrl $GitHubRepoUrl -RegistrationToken $registrationToken
}
