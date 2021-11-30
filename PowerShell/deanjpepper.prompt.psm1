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
	$isKubeCtlInstalled = Get-Command -ErrorAction SilentlyContinue kubectl

	if ($isKubeCtlInstalled) {
		$context = kubectl config current-context
		if ($context.Length -gt 0) {
			Write-Host "k8s:" -NoNewline -ForegroundColor DarkGray
			Write-Host $context -ForegroundColor Yellow
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
