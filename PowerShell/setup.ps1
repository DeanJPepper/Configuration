param (
    [Parameter(Mandatory = $false)][string]$option
)
Import-Module -Name "$PSScriptRoot/../Modules/Deploy/deploy.psm1"

$directoryDeploy = "$HOME/Documents"
$filterModule = "deanjpepper.*.psm1"

function Remove-CustomModule($directory) {
    Get-ChildItem $directory -Filter $filterModule -Recurse -Depth 2 | ForEach-Object {
        Unpublish-Module $_.Name "$directory/Modules"
    }
    Unregister-Module "deanjpepper.prompt" "$directory/Microsoft.PowerShell_profile.ps1"
    Unregister-Module "deanjpepper.prompt" "$directory/Microsoft.VSCode_profile.ps1"
}

function Add-CustomModule($directory) {
    Get-ChildItem $PSScriptRoot -Filter $filterModule | ForEach-Object {
        Publish-Module $_.Name $PSScriptRoot "$directory/Modules"
    }
    Register-Module "deanjpepper.prompt" "$directory/Microsoft.PowerShell_profile.ps1"
    Register-Module "deanjpepper.prompt" "$directory/Microsoft.VSCode_profile.ps1"
}

if ($option -Eq "remove") {
    Remove-CustomModule "$directoryDeploy/PowerShell"
    Remove-CustomModule "$directoryDeploy/WindowsPowerShell"
} else {
    Add-CustomModule "$directoryDeploy/PowerShell"
    Add-CustomModule "$directoryDeploy/WindowsPowerShell"
}

Remove-Module -Name "deploy"
