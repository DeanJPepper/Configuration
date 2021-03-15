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
			Write-Host $configFile -NoNewLine -ForegroundColor Red
		}
	}
}

function prompt {	
	Write-Host
	promptDirectory
	promptGit
	promptKubernetes		
	return "> "
}
