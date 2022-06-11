# PowerShell
Directory contains several PowerShell modules and a setup script.

## PowerShell Modules

### [deanjpepper.alias.psm1](deanjpepper.alias.psm1)
Adds aliases to the PowerShell prompt.
- Start a new instance of PowerShell in the current or specified directory.
    - `newps [directory]`
- Open Windows Explorer in the current or specified directory.
    - `ex [directory]`
- Create a directory and navigate into it.
    - `mkdircd <directory>`
- Encode the string in base-64.
    - `base64encode <string>`
- Decode the string from base-64.
    - `base64decode <base-64 encoded string>`
    
### [deanjpepper.git.psm1](deanjpepper.git.psm1)
Creates an alias `g` for the `git` command and provides functions for updating the PowerShell prompt when in a Git repository.

The Git prompt will show the branch name, tracking details, number of commits ahead/behind remote and number of any staged/unstaged files.
    
### [deanjpepper.notepadplusplus.psm1](deanjpepper.notepadplusplus.psm1)
Adds an alias to the PowerShell prompt if Notepad++ is installed.
- Open open a new or existing file.
    - `npp [file]`

### [deanjpepper.prompt.psm1](deanjpepper.prompt.psm1)
Changes the prompt when in a Git repository to show the Git prompt.

## Setup
[Setup.ps1](setup.ps1) will deploy (or re-deploy) the PowerShell modules to the `$HOME/Documents/WindowsPowerShell/Modules` directory and import the prompt module in the PowerShell Profile.
- `./setup.ps1`

Script can also be used to remove any setup.
- `./setup.ps1 remove`

Note: To enable script execution, the execution policy may need to be changed via ```Set-ExecutionPolicy unrestricted```.
