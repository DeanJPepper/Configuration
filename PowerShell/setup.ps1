param (
    [Parameter(Mandatory = $false)][string]$option
)
Import-Module -Name "$PSScriptRoot\..\Modules\deploy\deploy.psm1"

$directoryDeploy = "$HOME\Documents\WindowsPowerShell"
$directoryDeployModules = "$directoryDeploy\Modules"
$filterModule = "deanjpepper.*.psm1"

if ($option -Eq "remove") {
    Get-ChildItem $directoryDeploy -Filter $filterModule -Recurse -Depth 2 | ForEach-Object {
        ModuleRemove $_.Name $directoryDeployModules
    }
    PowerShellProfileModuleRemove "deanjpepper.prompt"
} else {
    Get-ChildItem $PSScriptRoot -Filter $filterModule | ForEach-Object {
        ModuleDeploy $_.Name $PSScriptRoot $directoryDeployModules
    }
    PowerShellProfileModuleAdd "deanjpepper.prompt"
}

Remove-Module -Name "deploy"
