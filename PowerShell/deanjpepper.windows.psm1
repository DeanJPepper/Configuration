# Open new instance of PowerShell
function newps {
	Start-Process powershell
}

# Open Windows Explorer (at current/specified directory)
function ex {
	if ([String]::IsNullOrWhiteSpace($args[0]))
	{
		explorer .
	}
	else{
		explorer $args[0]
	}
}

# Create a directory and change into it
function mkdircd {
	mkdir $args[0]
	Set-Location $args[0]
}

# Base 64 encode string
function base64encode {
	Write-Host ([System.Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($args[0])))
}

# Base 64 decode string
function base64decode {
	Write-Host ([Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($args[0])))
}
