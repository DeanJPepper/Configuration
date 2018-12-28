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
    $added = 0
    $modified = 0
	$renamed = 0
    $deleted = 0
    $untracked = $FALSE
    
    $output = git status --short --branch
   
    $output | foreach {
		if ($_ -match "^## (No commits yet on )?(?<branch>[^.]+)(.*?\[(ahead (?<ahead>\d))?.*?(behind (?<behind>\d))?\])?") {
			$branch = $matches["branch"]
			$ahead = $matches["ahead"]
			$behind = $matches["behind"]
		}
		else {
			if ($_ -match "^[ ]?A") {
				$added += 1
			}
			elseif ($_ -match "^[ ]?M") {
				$modified += 1
			}
			elseif ($_ -match "^[ ]?R") {
				$renamed += 1
			}
			elseif ($_ -match "^[ ]?D") {
				$deleted += 1
			}
			elseif ($_ -match "^\?") {
				$untracked = $TRUE
			}
		}
    }
    
    return @{"branch" = $branch;
			 "ahead" = $ahead;
             "behind" = $behind;
             "added" = $added;
             "modified" = $modified;
             "renamed" = $renamed;
             "deleted" = $deleted;
             "untracked" = $untracked;}
}
