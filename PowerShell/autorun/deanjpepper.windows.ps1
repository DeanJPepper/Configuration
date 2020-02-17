function newps 
{
	start powershell
}

function ex
{
	if ([String]::IsNullOrWhiteSpace($args[0]))
	{
		explorer .
	}
	else
	{
		explorer $args[0]
	}
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
