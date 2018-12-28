# Configuration
Change to PowerShell prompt and new Git aliases to save keystrokes and make development easier!

## PowerShell

### Alias

Creates an alias `g` for the `git` command.

### Git Prompt

Changes the prompt when in a Git repository to show the branch name, number of commits ahead/behind upstream and number of files added, modified, renamed, deleted and untracked.

### Installing
Copy the contents of [Microsoft.PowerShell_profile.ps1](Microsoft.PowerShell_profile.ps1) to `%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` and restart PowerShell.

To enable script execution, the execution policy may need to be changed.
```
Set-ExecutionPolicy unrestricted
```

## Git

### Example usage

Checkout develop (or a specified branch).
```
g ch
```

Add all changes to the index and create a commit.
```
g cma "It now works"
```

View the log in a tree with local and remote branches plus any stashes.
```
g lg
```

### Installing

Open the relevant configuration and copy the contents of [.gitconfig](.gitconfig) to the end of the file.
```
git config -e --local
git config -e --global
git config -e --system
```

