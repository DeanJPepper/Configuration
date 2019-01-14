# Creates alias for git
function gitAlias {
	git $args 
}
Set-Alias -name g -value gitAlias

# Returns whether the current directory is a git repository
function gitRepository {
    if ((Test-Path ".git") -eq $TRUE) {
        return $TRUE
    }
    
    $checkIn = (Get-Item .).parent
    while ($checkIn -ne $NULL) {
        $pathToTest = $checkIn.fullname + "/.git"
        if ((Test-Path $pathToTest) -eq $TRUE) {
            return $TRUE
        } else {
            $checkIn = $checkIn.parent
        }
    }
    
    return $FALSE
}

# Returns the name of git repository
function gitRepositoryName {
    if ((Test-Path ".git") -eq $TRUE) {
        return (Get-Item .).name
    }
    
    $checkIn = (Get-Item .).parent
    while ($checkIn -ne $NULL) {
        $pathToTest = $checkIn.fullname + "/.git"
        if ((Test-Path $pathToTest) -eq $TRUE) {
            return $checkIn.name
        } else {
            $checkIn = $checkIn.parent
        }
    }
    
    return ""
}

# Extracts name of the checked out branch
function gitBranchName {
    $currentBranch = ""
    git branch | foreach {
        if ($_ -match "^\* (.*)") {
            $currentBranch += $matches[1]
        }
    }
    return $currentBranch
}

# Extracts number of commits ahead/behind origin and number of any staged/unstaged files
function gitStatus {
	$branch = ""
	$branchTracking = $false
    $aheadMsg = ""
    $aheadCount = 0
    $behindMsg = ""
    $behindCount = 0
	$stagedMsg = ""
    $stagedCountModified = 0
    $stagedCountDeleted = 0
    $stagedCountRenamed = 0
    $stagedCountAdded = 0
	$unstagedMsg = ""
    $unstagedCountModified = 0
    $unstagedCountDeleted = 0
    $unstagedCountRenamed = 0
    $untrackedCount = 0
    
    $output = git status --short --branch
   
    $output | foreach {
		if ($_ -match "## (No commits yet on )?(?<branch>[^\[]+)((.*?)\[(ahead (?<ahead>(\d)*))?(, )?(behind (?<behind>(\d)*))?\])?") {	
			$branch = $matches["branch"]
			$aheadCount = $matches["ahead"]
			$behindCount = $matches["behind"]
			
			$posTracking = $branch.IndexOf('...')
			if ($posTracking -gt -1) {
				$branchTracking = $true
				$branch = $branch.SubString(0, $posTracking)
			}
			if ($aheadCount -gt 0) {
				$aheadMsg = " +" + $aheadCount
			}
			if ($behindCount -gt 0) {
				$behindMsg = " -" + $behindCount
			}
		}
		else {
			$counted = $FALSE
			# Staged
			if ($_ -match "^M") {
				$stagedCountModified += 1
				$counted = $TRUE
			}
			elseif ($_ -match "^D") {
				$stagedCountDeleted += 1
				$counted = $TRUE
			}
			elseif ($_ -match "^R") {
				$stagedCountRenamed += 1
				$counted = $TRUE
			}
			elseif ($_ -match "^A") {
				$stagedCountAdded += 1
				$counted = $TRUE
			}
			# Unstaged
			if ($_ -match "^.{1}M") {
				$unstagedCountModified += 1
				$counted = $TRUE
			}
			elseif ($_ -match "^.{1}D") {
				$unstagedCountDeleted += 1
				$counted = $TRUE
			}
			elseif ($_ -match "^.{1}R") {
				$unstagedCountRenamed += 1
				$counted = $TRUE
			}
			# Untracked
			if ($counted -eq $FALSE) {
				$untrackedCount += 1
			}
		}
    }
	
	# Staged
	if ($stagedCountModified -gt 0) {
		$stagedMsg += " m" + $stagedCountModified
	}
	if ($stagedCountDeleted -gt 0) {
		$stagedMsg += " d" + $stagedCountDeleted
	}
	if ($stagedCountRenamed -gt 0) {
		$stagedMsg += " r" + $stagedCountRenamed
	}
	if ($stagedCountAdded -gt 0) {
		$stagedMsg += " a" + $stagedCountAdded
	}
	
	# Unstaged
	if ($unstagedCountModified -gt 0) {
		$unstagedMsg += " m" + $unstagedCountModified
	}
	if ($unstagedCountDeleted -gt 0) {
		$unstagedMsg += " d" + $unstagedCountDeleted
	}
	if ($unstagedCountRenamed -gt 0) {
		$unstagedMsg += " r" + $unstagedCountRenamed
	}
	if ($untrackedCount -gt 0) {
		$unstagedMsg += " ?" + $untrackedCount
	}
    
    return @{"branch" = $branch;
             "branchTracking" = $branchTracking;
             "aheadMsg" = $aheadMsg;
             "aheadCount" = $aheadCount;
             "behindMsg" = $behindMsg;
             "behindCount" = $behindCount;
             "stagedMsg" = $stagedMsg;
             "stagedCountModified" = $stagedCountModified;
             "stagedCountDeleted" = $stagedCountDeleted;
             "stagedCountRenamed" = $stagedCountRenamed;
             "stagedCountAdded" = $stagedCountAdded;
             "unstagedMsg" = $unstagedMsg;
             "unstagedCountModified" = $unstagedCountModified;
             "unstagedCountDeleted" = $unstagedCountDeleted;
             "unstagedCountRenamed" = $unstagedCountRenamed;
             "untrackedCount" = $untrackedCount;}
}

# Updates the prompt to show the branch name, number of commits ahead/behind origin and number of any staged/unstaged files
function prompt {
    if (gitRepository) {
		$host.UI.RawUi.WindowTitle = "[" + (gitRepositoryName) + "] " + $ExecutionContext.SessionState.Path.CurrentLocation
		$status = gitStatus
				
		# Branch name
		if ($status["branchTracking"] -eq $true) {
			Write-Host "*" -nonewline
		}
		if ($status["aheadCount"] -gt 0) {
			Write-Host $status["branch"] -nonewline -foregroundcolor Red
		} elseif($status["behind"] -gt 0) {
			Write-Host $status["branch"] -nonewline -foregroundcolor Cyan
		} else {
			Write-Host $status["branch"] -nonewline -foregroundcolor Green
		}
				
		# Status
		Write-Host "[" -nonewline
		$aheadMsg = $status["aheadMsg"]
		$behindMsg = $status["behindMsg"]
		$stagedMsg = $status["stagedMsg"]
		$unstagedMsg = $status["unstagedMsg"]
		if (($aheadMsg -eq "") -and ($behindMsg -eq "") -and ($stagedMsg -eq "") -and ($unstagedMsg -eq "")) {
			Write-Host "clean" -nonewline -foregroundcolor Yellow
		} else {
			# Ahead
			if ($aheadMsg -ne "") {
				Write-Host $aheadMsg -nonewline -foregroundcolor Red
			}			
			# Behind
			if ($behindMsg -ne "") {
				Write-Host $behindMsg -nonewline -foregroundcolor Cyan
			}									
			# Staged
			if ($stagedMsg -ne "") {
				Write-Host $stagedMsg -nonewline -foregroundcolor DarkGreen
			}			
			# Unstaged
			if ($unstagedMsg -ne "") {
				Write-Host $unstagedMsg -nonewline -foregroundcolor Magenta
			}
			Write-Host " " -nonewline
		}
		Write-Host "]" -nonewline
		
	} else {
		$host.UI.RawUi.WindowTitle = $ExecutionContext.SessionState.Path.CurrentLocation
		Write-Host "PS" $ExecutionContext.SessionState.Path.CurrentLocation -nonewline
	}
	return "> "
}