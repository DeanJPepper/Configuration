function Set-GitConfig($name, $value) {
	if((git config $name) -ne $value) {
		Write-Host "Setting Git config '$name' to '$value'..."
		git config --global $name $value
	}
}

function Clear-GitConfig($name) {
	if(git config $name) {
		Write-Host "Clearing Git config '$name'..."
		git config --global --unset $name
	}
}

function New-Directory($directory){
	if (!(Test-Path $directory)) {
		Write-Host "Creating directory [$directory]..."
		New-Item $directory -ItemType Directory | Out-Null
	}
}

function Remove-Directory($directory){
	if (Test-Path $directory) {
		Write-Host "Removing directory [$directory]..."
		Remove-Item $directory
	}
}

function Publish-File($pathSource, $pathDestination) {
	Write-Host "Publishing file [$pathDestination]..."
	Copy-Item $pathSource $pathDestination -Force
}

function Unpublish-File($path) {
	if (Test-Path $path) {
		Write-Host "Unpublishing file [$path]..."
		Remove-Item $path -Force
	}
}

function Publish-Module($file, $directorySource, $directoryDeploy) {
	$module = [System.IO.Path]::GetFileNameWithoutExtension($file)
	$directoryModule = "$directoryDeploy/$module"
	New-Directory $directoryModule
	Publish-File "$directorySource/$file" "$directoryModule/$file"
	if (Get-Module $module) {
		Write-Host "Re-importing module [$module]..."
		Import-Module $module -Force
	}
}

function Unpublish-Module($file, $directoryDeploy) {
	$module = [System.IO.Path]::GetFileNameWithoutExtension($file)
	$directoryModule = "$directoryDeploy/$module"
	Unpublish-File "$directoryModule/$file"
	Remove-Directory $directoryModule
}

function Register-Module($module) {
	if (!(Test-Path $PROFILE)) {
		Write-Host "Creating file [$PROFILE]..."
		New-Item $PROFILE -ItemType "File" | Out-Null
	}

	if (!(Select-String -Path $PROFILE -Pattern $module)) {
		Write-Host "Adding module [$module] to PowerShell profile [$PROFILE]..."
		Add-Content $PROFILE " `r`nImport-Module $module"
	}
}

function Unregister-Module($module) {
	if (Select-String -Path $PROFILE -Pattern $module) {
		Write-Host "Removing module [$module] from PowerShell profile [$PROFILE]..."
		$content = (Get-Content $PROFILE -Raw) -Replace "Import-Module $module", ''
		Write-Output $content > $PROFILE
	}
}
