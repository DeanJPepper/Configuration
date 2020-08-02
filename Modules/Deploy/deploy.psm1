# Check whether the program/command is installed
function IsInstalled($command) {
	$isInstalled = Get-Command $command  -ErrorAction SilentlyContinue
	if ($isInstalled) {
		return $true
	} else {
		return $false
	}
}

# Set Git config name/value
function GitConfigSet($name, $value) {
	if((git config $name) -ne $value) {
		Write-Host "Setting Git config '$name' to '$value'..."
		git config --global $name $value
	}
}

# Remove Git config name
function GitConfigRemove($name) {
	if(git config $name) {
		Write-Host "Removing Git config '$name'..."
		git config --global --unset $name
	}
}

# Create empty file if it doesn't exist
function FileCreate($file){
	if (!(Test-Path $file)) {
		Write-Host "Creating file... [$file]"
		New-Item $file -ItemType "File" | Out-Null
	}
}

# Deploy specified file to host
function FileDeploy($file, $directorySource, $directoryDeploy) {
	$pathSource = "$directorySource\$file"
	$pathDestination = "$directoryDeploy\$file"
	$directoryDestination = [System.IO.Path]::GetDirectoryName($pathDestination)
	DirectoryCreate $directoryDestination
	Write-Host "Deploying file [$pathDestination]..."
	Copy-Item $pathSource $pathDestination -Force
}

# Remove specified file from host
function FileRemove($file, $directoryDeploy) {
	$path = "$directoryDeploy\$file"
	if (Test-Path $path) {
		Write-Host "Removing file [$path]..."
		Remove-Item $path -Force
	}
}

# Create directory if it doesn't exist
function DirectoryCreate($directory) {
	if (!(Test-Path $directory)) {
		Write-Host "Creating directory [$directory]..."
		mkdir $directory | Out-Null
	}
}

# Remove directory if it exists
function DirectoryRemove($directory) {
	if (Test-Path $directory) {
		Write-Host "Removing directory [$directory]..."
		rmdir $directoryModule
	}
}

# Deploy specified module to host
function ModuleDeploy($file, $directorySource, $directoryDeploy) {
	$module = [System.IO.Path]::GetFileNameWithoutExtension($file)
	$directoryModule = "$directoryDeploy\$module"
    FileDeploy $file $directorySource $directoryModule
}

# Remove specified module from host
function ModuleRemove($file, $directoryDeploy) {
	$module = [System.IO.Path]::GetFileNameWithoutExtension($file)
	$directoryModule = "$directoryDeploy\$module"
	FileRemove $file $directoryModule
	DirectoryRemove $directoryModule
}

# Path of PowerShell profile
$pathPowerShell = "$HOME\Documents\WindowsPowerShell"
$pathProfile = "$pathPowerShell\Microsoft.PowerShell_profile.ps1"

# Add specified module to PowerShell profile
function PowerShellProfileModuleAdd($module) {
	FileCreate $pathProfile
	if (!(Select-String -Path $pathProfile -Pattern $module)) {
		Write-Host "Adding module [$module] to PowerShell profile... [$pathProfile]"
		Add-Content $pathProfile " `r`nImport-Module $module"
	}
}

# Remove specified file from PowerShell profile
function PowerShellProfileModuleRemove($module) {
	if (Select-String -Path $pathProfile -Pattern $module) {
		Write-Host "Removing module [$module] from PowerShell profile... [$pathProfile]"
		$content = (Get-Content $pathProfile -Raw) -Replace "Import-Module $module", ''
		echo $content > $pathProfile
	}
}
