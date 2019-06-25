# Configuration
Changes PowerShell prompt and adds Git aliases to save keystrokes and make development easier!

## PowerShell

### Alias

Creates an alias `g` for the `git` command.

### Functions

Adds functions to the prompt.
`newps` Starts a new instance of PowerShell in the current directory.
`ex` Opens Windows Explorer in the current directory.
`mkdircd` Creates a directory and changes to that directory.

### Prompt

Changes the prompt when in a Git repository to show the branch name, number of commits ahead/behind origin and number of any staged/unstaged files.

## Git

### Example usage

Checkout develop (or a specified branch).
```
g ch
g ch feature/api
```

Add all changes to the index, commit changes and push to origin.
```
g ad
g cm "Added amazing new feature to API."
g ps
```

View the log in a tree with local and remote branches plus any stashes.
```
g lg
```

## Installing

### Initial Deploy
1. Run [deploy.ps1](deploy.ps1). This will NOT overwrite the `%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` file if it already exists so the contents of [PowerShell\profile.ps1](PowerShell\profile.ps1.ps1) will have to be manually added.

2. Open the global Git configuration with ```config --global -e``` and copy the below contents to the end of the file.
```
[include]
	path = deanjpepper.gitconfig
```

Note: To enable script execution, the execution policy may need to be changed via ```Set-ExecutionPolicy unrestricted```.

### Redeploy
1. Run [deploy.ps1](deploy.ps1)
2. Run `. $PROFILE`
