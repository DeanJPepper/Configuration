# Deploy PowerShell profile - only if file doesn't exist
Copy-Item .\PowerShell\profile.ps1 $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

# Deploy PowerShell autorun scripts - overwrite if file exists
Copy-Item .\PowerShell\autorun $HOME\Documents\WindowsPowerShell\ -Force -Recurse

# Deploy Git config - overwrite if file exists
Copy-Item .\Git\deanjpepper.gitconfig $HOME -Force
