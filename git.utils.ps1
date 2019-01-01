# Returns whether the current directory is a git repository
function gitRepository {
    if ((Test-Path ".git") -eq $TRUE) {
        return $TRUE
    }
    
    $checkIn = (Get-Item .).parent
    while ($checkIn -ne $NULL) {
        $pathToTest = $checkIn.fullname + '/.git'
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
        $pathToTest = $checkIn.fullname + '/.git'
        if ((Test-Path $pathToTest) -eq $TRUE) {
            return $checkIn.name
        } else {
            $checkIn = $checkIn.parent
        }
    }
    
    return ""
}

# Extracts the current branch name
function gitBranchName {
    $currentBranch = ''
    git branch | foreach {
        if ($_ -match "^\* (.*)") {
            $currentBranch += $matches[1]
        }
    }
    return $currentBranch
}

# Extracts details about branch status compared to upstream and any changed files
function gitStatus {
	$branch = ""
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
		if ($_ -match "## (No commits yet on )?(?<branch>[^.]+)((.*?)\[(ahead (?<ahead>(\d)*))?(, )?(behind (?<behind>(\d)*))?\])?") {	
			$branch = $matches["branch"]			
			$aheadCount = $matches["ahead"]
			$behindCount = $matches["behind"]
			
			if ($aheadCount -gt 0) {
				$aheadMsg = " +" + $aheadCount
			}
			if ($behindCount -gt 0) {
				$behindMsg = " -" + $behindCount
			}
		}
		else {
			# Staged
			if ($_ -match "^M") {
				$stagedCountModified += 1
			}
			elseif ($_ -match "^D") {
				$stagedCountDeleted += 1
			}
			elseif ($_ -match "^R") {
				$stagedCountRenamed += 1
			}
			elseif ($_ -match "^A") {
				$stagedCountAdded += 1
			}
			# Unstaged
			if ($_ -match "^.{1}M") {
				$unstagedCountModified += 1
			}
			elseif ($_ -match "^.{1}D") {
				$unstagedCountDeleted += 1
			}
			elseif ($_ -match "^.{1}R") {
				$unstagedCountRenamed += 1
			}
			# Untracked
			if ($_ -match "^\?") {
				$untrackedCount += 1
			}
		}
    }
	
	# Staged
	if ($stagedCountModified -gt 0) {
		$stagedMsg += ' m' + $stagedCountModified
	}
	if ($stagedCountDeleted -gt 0) {
		$stagedMsg += ' d' + $stagedCountDeleted
	}
	if ($stagedCountRenamed -gt 0) {
		$stagedMsg += ' r' + $stagedCountRenamed
	}
	if ($stagedCountAdded -gt 0) {
		$stagedMsg += ' a' + $stagedCountAdded
	}
	
	# Unstaged
	if ($unstagedCountModified -gt 0) {
		$unstagedMsg += ' m' + $unstagedCountModified
	}
	if ($unstagedCountDeleted -gt 0) {
		$unstagedMsg += ' d' + $unstagedCountDeleted
	}
	if ($unstagedCountRenamed -gt 0) {
		$unstagedMsg += ' r' + $unstagedCountRenamed
	}
	if ($untrackedCount -gt 0) {
		$unstagedMsg += ' ?' + $untrackedCount
	}
    
    return @{"branch" = $branch;
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
