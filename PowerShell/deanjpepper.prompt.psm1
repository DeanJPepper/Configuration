# Change the prompt to show the Git status or the current path
function prompt {
	$isGitInstalled = Get-Command -ErrorAction SilentlyContinue git
	if ($isGitInstalled -and $(gitPromptRelevant)) {
		gitPrompt
		return "> "
	}

	$host.UI.RawUi.WindowTitle = $ExecutionContext.SessionState.Path.CurrentLocation
	Write-Host "PS" $ExecutionContext.SessionState.Path.CurrentLocation -NoNewLine
	return "> "
}
