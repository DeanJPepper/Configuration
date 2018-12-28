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
		
		# Status
		if ($status["added"] -gt 0) {
			Write-Host(' a' + $status["added"]) -nonewline -foregroundcolor Yellow
		}
		if ($status["modified"] -gt 0) {
			Write-Host(' m' + $status["modified"]) -nonewline -foregroundcolor Yellow
		}
		if ($status["renamed"] -gt 0) {
			Write-Host(' r' + $status["renamed"]) -nonewline -foregroundcolor Yellow
		}
		if ($status["deleted"] -gt 0) {
			Write-Host(' d' + $status["deleted"]) -nonewline -foregroundcolor Yellow
		}
        if ($status["untracked"] -ne $FALSE) {
            Write-Host(' !') -nonewline -foregroundcolor Red
        }
		Write-Host(' ] ') -nonewline
	} else {
		Write-Host "PS" $ExecutionContext.SessionState.Path.CurrentLocation -nonewline
	}
	return ">"
}