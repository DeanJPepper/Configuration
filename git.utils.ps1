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

# Extracts details about;
# - branch status compared to upstream
# - number of any changed files
function gitStatus {
    $ahead = 0
    $behind = 0
    $stagedModified = 0
    $stagedDeleted = 0
	$stagedRenamed = 0
    $stagedAdded = 0
    $unstagedModified = 0
    $unstagedDeleted = 0
	$unstagedRenamed = 0
    $untracked = 0
    
    $output = git status --short --branch
   
    $output | foreach {
		if ($_ -match "^## (No commits yet on )?(?<branch>[^.]+)(.*?\[(ahead (?<ahead>\d))?.*?(behind (?<behind>\d))?\])?") {
			$branch = $matches["branch"]
			$ahead = $matches["ahead"]
			$behind = $matches["behind"]
		}
		else {
			# Staged
			if ($_ -match "^M") {
				$stagedModified += 1
			}
			elseif ($_ -match "^D") {
				$stagedDeleted += 1
			}
			elseif ($_ -match "^R") {
				$stagedRenamed += 1
			}
			elseif ($_ -match "^A") {
				$stagedAdded += 1
			}
			# Unstaged
			if ($_ -match "^.{1}M") {
				$unstagedModified += 1
			}
			elseif ($_ -match "^.{1}D") {
				$unstagedDeleted += 1
			}
			elseif ($_ -match "^.{1}R") {
				$unstagedRenamed += 1
			}
			# Untracked
			if ($_ -match "^\?") {
				$untracked += 1
			}
		}
    }
    
    return @{"branch" = $branch;
			 "ahead" = $ahead;
             "behind" = $behind;
             "stagedModified" = $stagedModified;
             "stagedDeleted" = $stagedDeleted;
             "stagedRenamed" = $stagedRenamed;
             "stagedAdded" = $stagedAdded;
             "unstagedModified" = $unstagedModified;
             "unstagedDeleted" = $unstagedDeleted;
             "unstagedRenamed" = $unstagedRenamed;
             "untracked" = $untracked;}
}
