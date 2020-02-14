function newps 
{
	start powershell
}

function ex 
{
	explorer .
}

function npp
{
	& 'C:\Program Files (x86)\Notepad++\notepad++.exe' $args[0]
}

function mkdircd
{
	mkdir $args[0]
	cd $args[0]
}
