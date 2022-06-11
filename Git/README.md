# Git
Directory contains a Git configuration file and a setup script.

## Git Configuration
Git configuration and aliases are contained in [.gitconfig](../.gitconfig).

## Git Editor
Git editor will be set to; Visual Studio Code, Notepad++ or Notepad.

## Example Workflow
Checkout an existing branch or create a new branch.
```
g ch feature/api
g chb bugfix/api
```

Once work is completed, add all changes to index and commit.
```
g ad
g cm "Created amazing API."
```

If a mistake is discovered, commit a single file as a fixup to head (or a specified commit).
```
g add src/file.cs
g cmf [commit]
```

Once work is compelted, add all changes and commit.
```
g ad
g cm "Added feature to API."
```

Rebase changes onto that branch (to remove the fixup and avoid merge commits), then push to remote.
```
g rb [branch]
g ps
```

View a summary of the most recent commits, which includes local and remote branches, tags and stashes.
```
g lg
```

## Setup
[Setup.ps1](setup.ps1) will deploy (or re-deploy) the Git config, [.gitconfig](../.gitconfig), to the `$HOME` directory, include that configuration in the global Git configuration and set the Git editor.
- `./setup.ps1`

Script can also be used to remove any setup.
- `./setup.ps1 remove`

Note: To enable script execution, the execution policy may need to be changed via ```Set-ExecutionPolicy unrestricted```.
