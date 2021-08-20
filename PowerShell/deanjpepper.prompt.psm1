function promptDirectory {
	$currentLoction = $ExecutionContext.SessionState.Path.CurrentLocation
	$host.UI.RawUi.WindowTitle = $currentLoction

	Write-Host "dir:" -NoNewline -ForegroundColor DarkGray
	Write-Host $currentLoction -ForegroundColor Yellow
}

function promptGit {
	$isGitInstalled = Get-Command -ErrorAction SilentlyContinue Get-IsGitRepository

	if ($isGitInstalled -and $(Get-IsGitRepository)) {
		Write-Host "git:" -NoNewline -ForegroundColor DarkGray
		Show-GitSummary
		Write-Host
	}
}

function promptKubernetes {
	$configFile = $env:KubeConfig

	if ($configFile) {
		Write-Host "k8s:" -NoNewline -ForegroundColor DarkGray
		if (Test-Path $configFile) {
			Write-Host $([System.IO.Path]::GetFileName($configFile)) -ForegroundColor Yellow
		} else {
			Write-Host $configFile -ForegroundColor Red
		}
	}
}

function promptEnd {
	$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	$isAdministrator = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

	if ($isAdministrator) {
		return "#> "
	}
	else {
		return "> "
	}
}

function prompt {
	Write-Host "---"
	promptDirectory
	promptGit
	promptKubernetes		
	return promptEnd
}
