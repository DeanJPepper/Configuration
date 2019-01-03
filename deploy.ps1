# Deploy the PowerShell profile
Copy-Item .\PowerShell\profile.ps1 ~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

# Deploy the autorun scripts
Copy-Item .\PowerShell\autorun ~\Documents\WindowsPowerShell\ -Force -Recurse
