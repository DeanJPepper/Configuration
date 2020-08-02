$nppexe = "C:\Program Files (x86)\Notepad++\notepad++.exe"
if (!(Test-Path $nppexe)) {
	return
}

function npp {
	& $nppexe $args[0]
}