<#

.SYNOPSIS
 
    Get-TeamsGuests.ps1 - Creates a CSV on the desktop of all Teams guests
 
.DESCRIPTION

    Author: csatswo

    This script will output a list of the Teams guests in the terminal and will save a CSV on the desktop.
    
.LINK

    Github: https://github.com/csatswo/Export-TeamsGuests.ps1
 
.EXAMPLE 
    
    .\Get-TeamsGuests.ps1 -username admin@domain.com -path C:\Temp\guests.csv

#>

# Script setup

Param(
    [Parameter(mandatory=$true)][String]$username,
    [Parameter(mandatory=$true)][String]$path
)

$teams = @()
$guests = @()

# Check for Teams module and install if missing

if (Get-Module -ListAvailable -Name MicrosoftTeams) {
    
    Write-Host "`nTeams module is installed" -ForegroundColor Cyan
    Import-Module MicrosoftTeams

} else {

    Write-Host "`nTeams module is not installed" -ForegroundColor Red
    Write-Host "`nInstalling module..." -ForegroundColor Cyan
    Install-Module MicrosoftTeams

}

# Connect to MS Teams

Import-Module MicrosoftTeams
Connect-MicrosoftTeams -AccountId $username
Add-Content -Path $path -Value "TeamName,GuestUser"
$teams = Get-Team
Foreach ($team in $teams) {
    $teamid = $team.GroupId
    $teamname = $team.DisplayName
    $guests = Get-TeamUser -GroupId $teamid -Role Guest
    Foreach ($guest in $guests) {
        $guestname = $guest.User
        Write-Host `n
        Write-Host ($teamname,$guestname) -Separator " --> " -ForegroundColor Yellow
        Add-Content -Path $path -Value "$teamname,$guestname"
        }
    }

Write-Host ""`nReport saved at" $path" -ForegroundColor Cyan
