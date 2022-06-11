param (
    [Parameter(Mandatory = $false)][string]$option
)
Import-Module -Name "$PSScriptRoot/../Modules/Deploy/deploy.psm1"

$directoryDeploy = "$HOME/Documents/WindowsPowerShell"
$directoryDeployModules = "$directoryDeploy/Modules"
$filterModule = "deanjpepper.*.psm1"

if ($option -Eq "remove") {
    Get-ChildItem $directoryDeploy -Filter $filterModule -Recurse -Depth 2 | ForEach-Object {
        Unpublish-Module $_.Name $directoryDeployModules
    }
    Unregister-Module "deanjpepper.prompt"
} else {
    Get-ChildItem $PSScriptRoot -Filter $filterModule | ForEach-Object {
        Publish-Module $_.Name $PSScriptRoot $directoryDeployModules
    }
    Register-Module "deanjpepper.prompt"
}

Remove-Module -Name "deploy"
