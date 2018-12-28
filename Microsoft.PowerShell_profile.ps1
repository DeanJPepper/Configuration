. (Resolve-Path ~\Documents\WindowsPowershell\git.utils.ps1)

function fnGit { 
	git $args
}
set-alias -name g -value fnGit

function prompt {
    if (gitRepository) {
        $status = gitStatus
        $currentBranch = $status["branch"]
		
		# Path
		$host.UI.RawUi.WindowTitle = $ExecutionContext.SessionState.Path.CurrentLocation

		# Branch (name and ahead/behind)
		if(($status["ahead"] -gt 0) -and ($status["behind"] -gt 0)) {
			Write-Host($currentBranch) -nonewline -foregroundcolor Red
			Write-Host(" [") -nonewline
			Write-Host(" +" + $status["ahead"]) -nonewline -foregroundcolor Red
			Write-Host(" -" + $status["behind"]) -nonewline -foregroundcolor Cyan
		}
		elseif($status["ahead"] -gt 0) {
			Write-Host($currentBranch) -nonewline -foregroundcolor Red
			Write-Host(" [") -nonewline
			Write-Host(" +" + $status["ahead"]) -nonewline -foregroundcolor Red
		}
		elseif($status["behind"] -gt 0) {
			Write-Host($currentBranch) -nonewline -foregroundcolor Cyan
			Write-Host(" [") -nonewline
			Write-Host(" -" + $status["behind"]) -nonewline -foregroundcolor Cyan
		} else {
			Write-Host($currentBranch) -nonewline -foregroundcolor Green
			Write-Host(" [") -nonewline
		}
		
		# Staged files
		if ($status["stagedModified"] -gt 0) {
			Write-Host(' m' + $status["stagedModified"]) -nonewline -foregroundcolor DarkGreen
		}
		if ($status["stagedDeleted"] -gt 0) {
			Write-Host(' d' + $status["stagedDeleted"]) -nonewline -foregroundcolor DarkGreen
		}
		if ($status["stagedRenamed"] -gt 0) {
			Write-Host(' r' + $status["stagedRenamed"]) -nonewline -foregroundcolor DarkGreen
		}
		if ($status["stagedAdded"] -gt 0) {
			Write-Host(' a' + $status["stagedAdded"]) -nonewline -foregroundcolor DarkGreen
		}
		# Unstaged files
		if ($status["unstagedModified"] -gt 0) {
			Write-Host(' m' + $status["unstagedModified"]) -nonewline -foregroundcolor Magenta
		}
		if ($status["unstagedDeleted"] -gt 0) {
			Write-Host(' d' + $status["unstagedDeleted"]) -nonewline -foregroundcolor Magenta
		}
		if ($status["unstagedRenamed"] -gt 0) {
			Write-Host(' r' + $status["unstagedRenamed"]) -nonewline -foregroundcolor Magenta
		}
		# Untracked files
        if ($status["untracked"] -gt 0) {
			Write-Host(' ?' + $status["untracked"]) -nonewline -foregroundcolor Magenta
        }
		Write-Host(' ] ') -nonewline
	} else {
		Write-Host "PS" $ExecutionContext.SessionState.Path.CurrentLocation -nonewline
	}
	return ">"
}