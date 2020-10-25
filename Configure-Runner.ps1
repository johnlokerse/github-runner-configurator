Import-Module -Force .\GitHub.Runner.PSFunctions.psm1

param (
    [Parameter(Mandatory = $true)]
    [string] $GitHubUserName,
    [Parameter(Mandatory = $true)]
    [string] $PAT
)

[string] $authToken = Get-GitHubAuthToken -GitHubUserName $GitHubUserName -PAT $PAT

if (-not $authToken -or $authToken -eq "Og==") {
    Write-Error -Message "'$authToken' is invalid" -ErrorAction Stop
}

Get-RunnerFiles
if (Test-Path -Path $PWD\*.cmd) {
    [string] $registrationToken = (Get-ProjectRegistrationToken -Owner johnlokerse -Repo github-runner-configurator -Base64AuthToken $authToken).token
    Install-Runner -GitHubRepoUrl https://github.com/johnlokerse/github-runner-configurator -RegistrationToken $registrationToken
}
