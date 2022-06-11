param (
    [Parameter(Mandatory = $false)][string]$option
)
Import-Module "$PSScriptRoot/../Modules/Deploy/deploy.psm1"

$directoryDeploy = "$HOME"
$fileSource = ".gitconfig"
$fileDeploy = ".deanjpepper.gitconfig"

$nppexe = "C:\Program Files (x86)\Notepad++\notepad++.exe"

if ($option -Eq "remove") {
    Unpublish-File "$directoryDeploy/$fileDeploy"
    Clear-GitConfig include.path
    Clear-GitConfig core.editor
} else {
    Publish-File "$PSScriptRoot/../$fileSource" "$directoryDeploy/$fileDeploy"
    Set-GitConfig include.path $fileDeploy
    if (Get-Command code -ErrorAction SilentlyContinue) {
        Set-GitConfig core.editor "code --wait"
    } elseif (Test-Path $nppexe) {
        Set-GitConfig core.editor "'$nppexe' -multiInst -notabbar -nosession -noPlugin"
    } elseif (Get-Command notepad -ErrorAction SilentlyContinue) {
        Set-GitConfig core.editor "notepad"
    } else {
        Write-Warning "Could not set default editor"
    }
}

Remove-Module "deploy"
