. (Resolve-Path ~\Documents\WindowsPowershell\git.utils.ps1)

function fnGit { 
	git $args
}
Set-Alias -name g -value fnGit

function prompt {
    if (gitRepository) {
		$host.UI.RawUi.WindowTitle = "[" + (gitRepositoryName) + "] " + $ExecutionContext.SessionState.Path.CurrentLocation
        $status = gitStatus
				
		# Branch name
		if($status["aheadCount"] -gt 0) {
			Write-Host($status["branch"]) -nonewline -foregroundcolor Red
		} elseif($status["behind"] -gt 0) {
			Write-Host($status["branch"]) -nonewline -foregroundcolor Cyan
		} else {
			Write-Host($status["branch"]) -nonewline -foregroundcolor Green
		}
				
		# Status
		$aheadMsg = $status["aheadMsg"]
		$behindMsg = $status["behindMsg"]
		$stagedMsg = $status["stagedMsg"]
		$unstagedMsg = $status["unstagedMsg"]
		Write-Host(" [") -nonewline
		if (($aheadMsg -eq "") -and ($behindMsg -eq "") -and ($stagedMsg -eq "") -and ($unstagedMsg -eq "")) {
			Write-Host(" clean") -nonewline -foregroundcolor Yellow
		} else {
			Write-Host($aheadMsg) -nonewline -foregroundcolor Red
			Write-Host($behindMsg) -nonewline -foregroundcolor Cyan
			Write-Host($stagedMsg) -nonewline -foregroundcolor DarkGreen
			Write-Host($unstagedMsg) -nonewline -foregroundcolor Magenta
		}
		Write-Host(' ] ') -nonewline
		
	} else {
		$host.UI.RawUi.WindowTitle = $ExecutionContext.SessionState.Path.CurrentLocation
		Write-Host "PS" $ExecutionContext.SessionState.Path.CurrentLocation -nonewline
	}
	return ">"
}