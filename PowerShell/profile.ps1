# Execute any autorun scripts
Get-ChildItem (Resolve-Path $HOME\Documents\WindowsPowershell\autorun\) -Filter *.ps1 | 
ForEach-Object {
	. $_.FullName
}
