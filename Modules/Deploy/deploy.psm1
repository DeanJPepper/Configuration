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
	if (!(Test-Path -Path $directory)) {
		Write-Host "Creating directory [$directory]..."
		New-Item $directory -ItemType Directory | Out-Null
	}
}

function Remove-Directory($directory){
	if (Test-Path -Path $directory) {
		Write-Host "Removing directory [$directory]..."
		Remove-Item $directory
	}
}

function Publish-File($pathSource, $pathDestination) {
	if (!(Test-Path -Path $pathDestination) ) {
		Write-Host "Publishing file [$pathDestination]..."
		Copy-Item $pathSource $pathDestination -Force
	}

	if (Compare-Object -ReferenceObject (Get-Content -Path $pathSource) -DifferenceObject (Get-Content -Path $pathDestination)){
		Write-Host "Re-publishing file [$pathDestination]..."
		Copy-Item $pathSource $pathDestination -Force
	}
}

function Unpublish-File($path) {
	if (Test-Path -Path $path) {
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

function Register-Module($module, $profileFile) {
	if (!(Test-Path -Path $profileFile)) {
		Write-Host "Creating file [$profileFile]..."
		New-Item -Path $profileFile -ItemType "File" | Out-Null
	}

	if (!(Select-String -Path $profileFile -Pattern $module)) {
		Write-Host "Adding module [$module] to PowerShell profile [$profileFile]..."
		Add-Content -Path $profileFile " `r`nImport-Module $module"
	}
}

function Unregister-Module($module, $profileFile) {
	if (!(Test-Path -Path $profileFile)) {
		return
	}
	if (Select-String -Path $profileFile -Pattern $module) {
		Write-Host "Removing module [$module] from PowerShell profile [$profileFile]..."
		$content = (Get-Content $profileFile -Raw) -Replace "Import-Module $module", ''
		Write-Output $content > $profileFile
	}
}
