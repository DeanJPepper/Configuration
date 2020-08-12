# Change the prompt to show the Git status or the current path
function prompt {
	$currentLoction = $ExecutionContext.SessionState.Path.CurrentLocation
	$host.UI.RawUi.WindowTitle = $currentLoction
	Write-Host "$env:UserName@$env:ComputerName " -NoNewLine -ForegroundColor DarkGray
	
	$isGitInstalled = Get-Command -ErrorAction SilentlyContinue git
	if ($isGitInstalled -and $(Get-IsGitRepository)) {
		Show-GitSummary
	} else {
		Write-Host $currentLoction -NoNewLine -ForegroundColor Yellow
	}
	
	return "> "
}
