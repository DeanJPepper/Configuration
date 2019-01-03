# Configuration
Changes PowerShell prompt and adds Git aliases to save keystrokes and make development easier!

## PowerShell

### Alias

Creates an alias `g` for the `git` command.

### Git Prompt

Changes the prompt when in a Git repository to show the branch name, number of commits ahead/behind origin and number of any staged/unstaged files.

### Installing
Run the [deploy.ps1](deploy.ps1) file and restart PowerShell.

Note: This will NOT overwrite the `%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` file if it already exists so the contents will have to be manually added.

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

