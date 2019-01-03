# Execute any autorun scripts
Get-ChildItem (Resolve-Path ~\Documents\WindowsPowershell\autorun\) -Filter *.ps1 | 
ForEach-Object {
	. $_.FullName
}
