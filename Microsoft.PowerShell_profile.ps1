. (Resolve-Path ~\Documents\WindowsPowershell\git.utils.ps1)

function fnGit { 
	git $args
}
Set-Alias -name g -value fnGit

function prompt {
    if (gitRepository) {
		$host.UI.RawUi.WindowTitle = "[" + (gitRepositoryName) + "] " + $ExecutionContext.SessionState.Path.CurrentLocation
        $status = gitStatus
        $currentBranch = $status["branch"]
				
		# Branch (name and ahead/behind)
		$ahead = ""
		$behind = ""
		if(($status["ahead"] -gt 0) -and ($status["behind"] -gt 0)) {
			Write-Host($currentBranch) -nonewline -foregroundcolor Red
			$ahead = " +" + $status["ahead"]
			$behind = " -" + $status["behind"]
		}
		elseif($status["ahead"] -gt 0) {
			Write-Host($currentBranch) -nonewline -foregroundcolor Red
			$ahead = " +" + $status["ahead"]
		}
		elseif($status["behind"] -gt 0) {
			Write-Host($currentBranch) -nonewline -foregroundcolor Cyan
			$behind = " -" + $status["behind"]
		} else {
			Write-Host($currentBranch) -nonewline -foregroundcolor Green
		}		
		
		# Staged files
		$stagedFiles = ""
		if ($status["stagedModified"] -gt 0) {
			$stagedFiles += ' m' + $status["stagedModified"]
		}
		if ($status["stagedDeleted"] -gt 0) {
			$stagedFiles += ' d' + $status["stagedDeleted"]
		}
		if ($status["stagedRenamed"] -gt 0) {
			$stagedFiles += ' r' + $status["stagedRenamed"]
		}
		if ($status["stagedAdded"] -gt 0) {
			$stagedFiles += ' a' + $status["stagedAdded"]
		}
		
		# Unstaged files
		$unstagedFiles = ""
		if ($status["unstagedModified"] -gt 0) {
			$unstagedFiles += ' m' + $status["unstagedModified"]
		}
		if ($status["unstagedDeleted"] -gt 0) {
			$unstagedFiles += ' d' + $status["unstagedDeleted"]
		}
		if ($status["unstagedRenamed"] -gt 0) {
			$unstagedFiles += ' r' + $status["unstagedRenamed"]
		}
        if ($status["untracked"] -gt 0) {
			$unstagedFiles += ' ?' + $status["untracked"]
        }
		
		# Status
		Write-Host(" [") -nonewline
		if (($ahead -eq "") -and ($behind -eq "") -and ($stagedFiles -eq "") -and ($unstagedFiles -eq "")) {
			Write-Host(" clean") -nonewline -foregroundcolor Yellow
		} else {
			Write-Host($ahead) -nonewline -foregroundcolor Red
			Write-Host($behind) -nonewline -foregroundcolor Cyan
			Write-Host($stagedFiles) -nonewline -foregroundcolor DarkGreen
			Write-Host($unstagedFiles) -nonewline -foregroundcolor Magenta
		}
		Write-Host(' ] ') -nonewline
		
	} else {
		$host.UI.RawUi.WindowTitle = $ExecutionContext.SessionState.Path.CurrentLocation
		Write-Host "PS" $ExecutionContext.SessionState.Path.CurrentLocation -nonewline
	}
	return ">"
}