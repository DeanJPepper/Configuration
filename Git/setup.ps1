param (
    [Parameter(Mandatory = $false)][string]$option
)
Import-Module "$PSScriptRoot\..\Modules\deploy\deploy.psm1"

$directoryDeploy = "$HOME"
$file = "deanjpepper.gitconfig"

if ($option -Eq "remove") {
    FileRemove $file $directoryDeploy
    GitConfigRemove include.path
    GitConfigRemove core.editor
} else {
    FileDeploy $file $PSScriptRoot $directoryDeploy
    GitConfigSet include.path $file
    $nppexe = "C:\Program Files (x86)\Notepad++\notepad++.exe"
    if (IsInstalled code) {
        GitConfigSet core.editor "code --wait"
    } elseif (Test-Path $nppexe) {
        GitConfigSet core.editor "'$nppexe' -multiInst -notabbar -nosession -noPlugin"
    } elseif (IsInstalled notepad) {
        GitConfigSet core.editor "notepad"
    } else {
        Write-Warning "Could not set default editor"
    }
}

Remove-Module "deploy"
