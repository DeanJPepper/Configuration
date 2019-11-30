# Creates aliases for git
Set-Alias -name g -value gitAlias
Set-Alias -name gst -value gitWriteStatusTree
function gitAlias {
	git $args 
}

# Returns whether the current directory is a git repository (or within a git repository)
function gitGetIsRepository {
    if ((Test-Path ".git") -eq $TRUE) {
        return $TRUE
    }
    $checkIn = (Get-Item .).Parent
    while ($checkIn -ne $NULL) {
        if ((Test-Path ($checkIn.FullName + "/.git")) -eq $TRUE) {
            return $TRUE
        } else {
            $checkIn = $checkIn.Parent
        }
    }
    return $FALSE
}

# Returns the name of git repository
function gitGetRepositoryName {
    if ((Test-Path ".git") -eq $TRUE) {
        return (Get-Item .).Name
    }
    $checkIn = (Get-Item .).Parent
    while ($checkIn -ne $NULL) {
        if ((Test-Path ($checkIn.FullName + "/.git")) -eq $TRUE) {
            return $checkIn.Name
        } else {
            $checkIn = $checkIn.Parent
        }
    }
    return ""
}

# Returns the name of git sub-directory
function gitGetSubDirectoryName {
    if ((Test-Path ".git") -eq $TRUE) {
        return ""
    }
	$subdirectory = (Get-Item .).Name
    $checkIn = (Get-Item .).Parent
    while ($checkIn -ne $NULL) {
        if ((Test-Path ($checkIn.FullName + "/.git")) -eq $TRUE) {
            return $subdirectory
        } else {
			$subdirectory = $checkIn.Name + "\" + $subdirectory
            $checkIn = $checkIn.Parent
        }
    }
    return ""
}

# Returns name of the checked out branch
function gitGetBranchName {
    if (gitGetIsRepository) {
		$currentBranch = ""
		git branch | foreach {
			if ($_ -match "^\* (.*)") {
				$currentBranch += $matches[1]
			}
		}
		return $currentBranch
	}
    return ""
}

# Returns branch tracking details, number of commits ahead/behind origin and number of any staged/unstaged files
function gitGetStatusDetail {
    if (gitGetIsRepository) {
		$branch = ""
		$branchTracking = $false
		$aheadCount = 0
		$behindCount = 0
		$stagedCountModified = 0
		$stagedCountDeleted = 0
		$stagedCountRenamed = 0
		$stagedCountAdded = 0
		$unstagedCountModified = 0
		$unstagedCountDeleted = 0
		$unstagedCountRenamed = 0
		$untrackedCount = 0
		
		$output = git status --short --branch
	   
		$output | foreach {
			if ($_ -match "## (No commits yet on )?(?<branch>[^\[]+)((.*?)\[(ahead (?<ahead>(\d)*))?(, )?(behind (?<behind>(\d)*))?\])?") {	
				# Branch
				$branch = $matches["branch"]
				
				# Commits
				$aheadCount = $matches["ahead"]
				$behindCount = $matches["behind"]
				
				# Tracking
				$posTracking = $branch.IndexOf('...')
				if ($posTracking -gt -1) {
					$branchTracking = $true
					$branch = $branch.SubString(0, $posTracking)
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
		
		return @{"branch" = $branch;
				 "branchTracking" = $branchTracking;
				 "aheadCount" = $aheadCount;
				 "behindCount" = $behindCount;
				 "stagedCountModified" = $stagedCountModified;
				 "stagedCountDeleted" = $stagedCountDeleted;
				 "stagedCountRenamed" = $stagedCountRenamed;
				 "stagedCountAdded" = $stagedCountAdded;
				 "unstagedCountModified" = $unstagedCountModified;
				 "unstagedCountDeleted" = $unstagedCountDeleted;
				 "unstagedCountRenamed" = $unstagedCountRenamed;
				 "untrackedCount" = $untrackedCount;}
	}
}

# Writes to the host the branch name, number of commits ahead/behind origin and number of any staged/unstaged files
function gitWriteStatus {
    if (gitGetIsRepository) {
		$delimiter = "|"
		$colorDelimiter = "Gray"
		$colorRepoName = "White"
		$colorAhead = "Red"
		$colorBehind = "Cyan"
		$colorSync = "Green"
		$colorNotTracking = "Yellow"
		$colorStaged = "DarkGreen"
		$colorUnstaged = "Magenta"
		$colorSubDirectory = "DarkGray"
		
		# Status
		$status = gitGetStatusDetail
		$branchName = $status["branch"]
		$branchTracking = $status["branchTracking"]
		$aheadCount = $status["aheadCount"]
		$behindCount = $status["behindCount"]
		$stagedCountModified = $status["stagedCountModified"]
		$stagedCountDeleted = $status["stagedCountDeleted"]
		$stagedCountRenamed = $status["stagedCountRenamed"]
		$stagedCountAdded = $status["stagedCountAdded"]
		$unstagedCountModified = $status["unstagedCountModified"]
		$unstagedCountDeleted = $status["unstagedCountDeleted"]
		$unstagedCountRenamed = $status["unstagedCountRenamed"]
		$untrackedCount = $status["untrackedCount"]
		$subDirectoryName = gitGetSubDirectoryName
		$repositoryName = gitGetRepositoryName

		# Repository name
		Write-Host "$repositoryName" -NoNewLine -ForegroundColor $colorRepoName
		
		# Branch name
		$branchNameShort = $branchName
		if ($branchName.Length -gt 30) {
			$branchNameShort = $branchName.SubString(0, 27) + "..."
		}
		Write-Host $delimiter -NoNewLine -ForegroundColor $colorDelimiter
		if ($aheadCount -gt 0) {
			# Ahead
			Write-Host $branchNameShort -NoNewLine -ForegroundColor $colorAhead
		} elseif($behindCount -gt 0) {
			# Behind
			Write-Host $branchNameShort -NoNewLine -ForegroundColor $colorBehind
		} elseif ($branchTracking -eq $true) {
			# Sync
			Write-Host $branchNameShort -NoNewLine -ForegroundColor $colorSync
		} else {
			# Not tracking
			Write-Host $branchNameShort -NoNewLine -ForegroundColor $colorNotTracking
		}
		
		# Ahead
		if ($aheadCount -gt 0) {
			Write-Host $delimiter -NoNewLine -ForegroundColor $colorDelimiter
			Write-Host "+$aheadCount" -NoNewLine -ForegroundColor $colorAhead
		}			
		# Behind
		if ($behindCount -gt 0) {
			Write-Host $delimiter -NoNewLine -ForegroundColor $colorDelimiter
			Write-Host "-$behindCount" -NoNewLine -ForegroundColor $colorBehind
		}									
		# Staged	
		if ($stagedCountModified -gt 0) {
			Write-Host $delimiter -NoNewLine -ForegroundColor $colorDelimiter
			Write-Host "m$stagedCountModified" -NoNewLine -ForegroundColor $colorStaged
		}
		if ($stagedCountDeleted -gt 0) {
			Write-Host $delimiter -NoNewLine -ForegroundColor $colorDelimiter
			Write-Host "d$stagedCountDeleted" -NoNewLine -ForegroundColor $colorStaged
		}
		if ($stagedCountRenamed -gt 0) {
			Write-Host $delimiter -NoNewLine -ForegroundColor $colorDelimiter
			Write-Host "r$stagedCountRenamed" -NoNewLine -ForegroundColor $colorStaged
		}
		if ($stagedCountAdded -gt 0) {
			Write-Host $delimiter -NoNewLine -ForegroundColor $colorDelimiter
			Write-Host "a$stagedCountAdded" -NoNewLine -ForegroundColor $colorStaged
		}
		# Unstaged
		if ($unstagedCountModified -gt 0) {
			Write-Host $delimiter -NoNewLine -ForegroundColor $colorDelimiter
			Write-Host "m$unstagedCountModified" -NoNewLine -ForegroundColor $colorUnstaged
		}
		if ($unstagedCountDeleted -gt 0) {
			Write-Host $delimiter -NoNewLine -ForegroundColor $colorDelimiter
			Write-Host "d$unstagedCountDeleted" -NoNewLine -ForegroundColor $colorUnstaged
		}
		if ($unstagedCountRenamed -gt 0) {
			Write-Host $delimiter -NoNewLine -ForegroundColor $colorDelimiter
			Write-Host "r$unstagedCountRenamed" -NoNewLine -ForegroundColor $colorUnstaged
		}
		if ($untrackedCount -gt 0) {
			Write-Host $delimiter -NoNewLine -ForegroundColor $colorDelimiter
			Write-Host "?$untrackedCount" -NoNewLine -ForegroundColor $colorUnstaged
		}
		
		# Sub-directory
		if ($subDirectoryName -ne "") {
			Write-Host $delimiter -NoNewLine -ForegroundColor $colorDelimiter
			Write-Host $subDirectoryName -NoNewLine -ForegroundColor $colorSubDirectory
		}
	}
}

# Writes to the host the repository name and status for every repository in the tree
function gitWriteStatusTree {
	Get-ChildItem | 
	? { $_.PSIsContainer; } | 
	% { 
		Push-Location $_.FullName;
		if (gitGetIsRepository) {
			gitWriteStatus;
			Write-Host "";
		}
		Pop-Location;
	}
}

# Cleans up the local repo by deleting branches which have been merged
function gitClean {
    git branch | foreach {
        if ($_ -match "^  ((feature|bugfix|hotfix)/(.*))") {
			git branch --delete $matches[1]
        }
    }
}

# Updates the prompt to show the git status or the regular prompt
function prompt {
    if (gitGetIsRepository) {
		$host.UI.RawUi.WindowTitle = "[" + (gitGetRepositoryName) + "] (" + (gitGetBranchName) + ") "
		Write-Host "Git " -NoNewLine
		gitWriteStatus
	} else {
		$host.UI.RawUi.WindowTitle = $ExecutionContext.SessionState.Path.CurrentLocation
		Write-Host "PS" $ExecutionContext.SessionState.Path.CurrentLocation -NoNewLine
	}
	return "> "
}