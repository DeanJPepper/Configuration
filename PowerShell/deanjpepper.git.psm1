$isGitInstalled = Get-Command -ErrorAction SilentlyContinue git
if (!$isGitInstalled) {
	return
}

$gitPromptEnabled = $true
$gitBranchNameLength = 30
$gitDelilmiter = "|"
$gitColorDelimiter = "Gray"
$gitColorRepoName = "Black"
$gitColorAhead = "Red"
$gitColorBehind = "Cyan"
$gitColorSync = "Green"
$gitColorNotTracking = "Yellow"
$gitColorStaged = "DarkGreen"
$gitColorUnstaged = "Magenta"
$gitColorSubDirectory = "DarkGray"
$gitBackgroundColourRepoName = "White"

# Create alias for Git
function g {
	git $args 
}

# Return whether the current directory is a git repository (or within a git repository)
function gitGetIsRepository {
	$repoName = gitGetRepositoryName
	if ($repoName) {
		return $true
	} else {
		return $false
	}
}

# Return the name of git repository
function gitGetRepositoryName {
	if (Test-Path ".git") {
		return (Get-Item .).Name
	}
	$checkIn = (Get-Item .).Parent
	while ($checkIn -ne $NULL) {
		if (Test-Path ($checkIn.FullName + "/.git")) {
			return $checkIn.Name
		} else {
			$checkIn = $checkIn.Parent
		}
	}
	return ""
}

# Return the name of git sub-directory
function gitGetSubDirectoryName {
	if (Test-Path ".git") {
		return ""
	}
	$subdirectory = (Get-Item .).Name
	$checkIn = (Get-Item .).Parent
	while ($checkIn -ne $NULL) {
		if (Test-Path ($checkIn.FullName + "/.git")) {
			return $subdirectory
		} else {
			$subdirectory = $checkIn.Name + "\" + $subdirectory
			$checkIn = $checkIn.Parent
		}
	}
	return ""
}

# Return name of the checked out branch
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

# Return branch name, tracking details, number of commits ahead/behind remote and number of any staged/unstaged files
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
				$counted = $false
				# Staged
				if ($_ -match "^M") {
					$stagedCountModified += 1
					$counted = $true
				}
				elseif ($_ -match "^D") {
					$stagedCountDeleted += 1
					$counted = $true
				}
				elseif ($_ -match "^R") {
					$stagedCountRenamed += 1
					$counted = $true
				}
				elseif ($_ -match "^A") {
					$stagedCountAdded += 1
					$counted = $true
				}
				# Unstaged
				if ($_ -match "^.{1}M") {
					$unstagedCountModified += 1
					$counted = $true
				}
				elseif ($_ -match "^.{1}D") {
					$unstagedCountDeleted += 1
					$counted = $true
				}
				elseif ($_ -match "^.{1}R") {
					$unstagedCountRenamed += 1
					$counted = $true
				}
				# Untracked
				if ($counted -eq $false) {
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

# Write to the host the branch name, tracking details, number of commits ahead/behind remote and number of any staged/unstaged files
function gitWriteStatus {
	if (gitGetIsRepository) {		
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
		Write-Host "$repositoryName" -NoNewLine -ForegroundColor $gitColorRepoName -BackgroundColor $gitBackgroundColourRepoName
		
		# Branch name
		$branchNamePrompt = $branchName
		if ($branchName.Length -gt $gitBranchNameLength) {
			$branchNamePrompt = $branchName.SubString(0, [System.Math]::Max(0,$gitBranchNameLength-3)) + "..."
		}
		Write-Host $gitDelilmiter -NoNewLine -ForegroundColor $gitColorDelimiter
		if ($aheadCount -gt 0) {
			# Ahead
			Write-Host $branchNamePrompt -NoNewLine -ForegroundColor $gitColorAhead
		} elseif($behindCount -gt 0) {
			# Behind
			Write-Host $branchNamePrompt -NoNewLine -ForegroundColor $gitColorBehind
		} elseif ($branchTracking) {
			# Sync
			Write-Host $branchNamePrompt -NoNewLine -ForegroundColor $gitColorSync
		} else {
			# Not tracking
			Write-Host $branchNamePrompt -NoNewLine -ForegroundColor $gitColorNotTracking
		}
		
		# Ahead
		if ($aheadCount -gt 0) {
			Write-Host $gitDelilmiter -NoNewLine -ForegroundColor $gitColorDelimiter
			Write-Host "+$aheadCount" -NoNewLine -ForegroundColor $gitColorAhead
		}			
		# Behind
		if ($behindCount -gt 0) {
			Write-Host $gitDelilmiter -NoNewLine -ForegroundColor $gitColorDelimiter
			Write-Host "-$behindCount" -NoNewLine -ForegroundColor $gitColorBehind
		}									
		# Staged	
		if ($stagedCountModified -gt 0) {
			Write-Host $gitDelilmiter -NoNewLine -ForegroundColor $gitColorDelimiter
			Write-Host "m$stagedCountModified" -NoNewLine -ForegroundColor $gitColorStaged
		}
		if ($stagedCountDeleted -gt 0) {
			Write-Host $gitDelilmiter -NoNewLine -ForegroundColor $gitColorDelimiter
			Write-Host "d$stagedCountDeleted" -NoNewLine -ForegroundColor $gitColorStaged
		}
		if ($stagedCountRenamed -gt 0) {
			Write-Host $gitDelilmiter -NoNewLine -ForegroundColor $gitColorDelimiter
			Write-Host "r$stagedCountRenamed" -NoNewLine -ForegroundColor $gitColorStaged
		}
		if ($stagedCountAdded -gt 0) {
			Write-Host $gitDelilmiter -NoNewLine -ForegroundColor $gitColorDelimiter
			Write-Host "a$stagedCountAdded" -NoNewLine -ForegroundColor $gitColorStaged
		}
		# Unstaged
		if ($unstagedCountModified -gt 0) {
			Write-Host $gitDelilmiter -NoNewLine -ForegroundColor $gitColorDelimiter
			Write-Host "m$unstagedCountModified" -NoNewLine -ForegroundColor $gitColorUnstaged
		}
		if ($unstagedCountDeleted -gt 0) {
			Write-Host $gitDelilmiter -NoNewLine -ForegroundColor $gitColorDelimiter
			Write-Host "d$unstagedCountDeleted" -NoNewLine -ForegroundColor $gitColorUnstaged
		}
		if ($unstagedCountRenamed -gt 0) {
			Write-Host $gitDelilmiter -NoNewLine -ForegroundColor $gitColorDelimiter
			Write-Host "r$unstagedCountRenamed" -NoNewLine -ForegroundColor $gitColorUnstaged
		}
		if ($untrackedCount -gt 0) {
			Write-Host $gitDelilmiter -NoNewLine -ForegroundColor $gitColorDelimiter
			Write-Host "?$untrackedCount" -NoNewLine -ForegroundColor $gitColorUnstaged
		}
		
		# Sub-directory
		if ($subDirectoryName -ne "") {
			Write-Host $gitDelilmiter -NoNewLine -ForegroundColor $gitColorDelimiter
			Write-Host $subDirectoryName -NoNewLine -ForegroundColor $gitColorSubDirectory
		}
	}
}

# Write to the host the repository name and status for every repository in the tree
Set-Alias -name gst -value gitWriteStatusTree
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

# Pull the develop (or current) branch for every repository in the tree
function gitPullTree {
	Get-ChildItem | 
	? { $_.PSIsContainer; } | 
	% { 
		Push-Location $_.FullName;
		if (gitGetIsRepository) {
			Write-Host (gitGetRepositoryName) -ForegroundColor $gitColorRepoName -BackgroundColor $gitBackgroundColourRepoName;
			git checkout develop;
			git pull;
			gitWriteStatus;
			Write-Host "";
			Write-Host "";
		}
		Pop-Location;
	}
}

# Clean up the repository by deleting branches which have been merged
function gitClean {
	git branch | foreach {
		if ($_ -match "^  ((feature|bugfix|hotfix)/(.*))") {
			git branch --delete $matches[1]
		}
	}
}

# Return whether the Git primpt should be used
function gitPromptRelevant {
	$isGitRepo = gitGetIsRepository
	if ($isGitRepo -and $gitPromptEnabled) {
		return $true
	} else {
		return $false
	}
}

# Update the prompt to show the git status
function gitPrompt {
	$host.UI.RawUi.WindowTitle = "[" + (gitGetRepositoryName) + "] (" + (gitGetBranchName) + ")"
	gitWriteStatus
	return "> "
}
