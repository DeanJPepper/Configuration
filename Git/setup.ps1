param (
    [Parameter(Mandatory = $false)][string]$option
)
Import-Module "$PSScriptRoot\..\Modules\deploy\deploy.psm1"

$directoryDeploy = "$HOME"
$file = "deanjpepper.gitconfig"

if ($option -Eq "remove") {
    Unpublish-File $file $directoryDeploy
    Clear-GitConfig include.path
    Clear-GitConfig core.editor
} else {
    Publish-File $file $PSScriptRoot $directoryDeploy
    Set-GitConfig include.path $file
    $nppexe = "C:\Program Files (x86)\Notepad++\notepad++.exe"
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
