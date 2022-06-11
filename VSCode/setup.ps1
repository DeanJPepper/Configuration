param (
    [Parameter(Mandatory = $false)][string]$option
)
Import-Module -Name "$PSScriptRoot\..\Modules\deploy\deploy.psm1"

$directoryDeploy = "$HOME\AppData\Roaming\Code\User"
$files = ("keybindings.json", "settings.json")

if ($option -Eq "remove") {
    $files | ForEach-Object {
        Unpublish-File "$directoryDeploy/$_"
    }
} else {
    $files | ForEach-Object {
        Publish-File "$PSScriptRoot/$_" "$directoryDeploy/$_"
    }
}

Remove-Module -Name "deploy"
