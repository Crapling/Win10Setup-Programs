# for more information about this script refer to my Win10Setup-Debloat Script: https://github.com/Crapling/Win10Setup-Debloat

$tweaks = @(
	"InstallChoco",
    "InstallFirefox",
    "InstallDiscord",
    "InstallJava",
	"InstallWSL2",
	"InstallUbuntuForWSL",
	"InstallPutty",
	"InstallWinSCP",
	"InstallNeovim",
	"InstallPaintDotNet",
	"InstallThunderbird",
	"InstallLinkShellExtension",
	"InstallUninstallView",
	"InstallQBitTorrent"
)

$global:IsInitialized = 0
$global:Default = 0
$global:InstallEverything = 0
$global:DriveLetters

# installing Chocolatey and provide the option to move the default install drive
Function InstallChoco {
	$Title = ""
	$Message = "To Install Chocolatey hit I or R to also change the installation drive for all chocolatey installed programs"
	$Options = "&Install", "&RelocateAndInstall"
	Write-Output "About to install Chocolatey"
    Write-Warning -Message "This is required for installing programs with this script"
	$DefaultChoice = 0
	$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

	if($Result -eq 1){
		initDrives
		$Title = "`nSelect the drive where Chocolatey should be installed"
		$SelectedDrive = ShowMenu -Title $Title -Menu $global:DriveLetters -Default $global:Default
		$New_Location = "${SelectedDrive}:\Program Files (x86)\Chocolatey"
		if ("$env:ChocolateyInstall" -AND $SelectedDrive -ne $env:ChocolateyInstall.Substring(0,1)) {
			Move-Item -force "$env:ChocolateyInstall" "${SelectedDrive}:\Program Files (x86)"
		} elseif (!("$env:ChocolateyInstall")) {
			$Result = 0
		}
		[System.Environment]::SetEnvironmentVariable("ChocolateyInstall","${SelectedDrive}:\Program Files (x86)\Chocolatey",[System.EnvironmentVariableTarget]::Machine)
		Write-Output "Parsing Environment Variable..."
		# reinit environment variable
		$env:ChocolateyInstall = [System.Environment]::GetEnvironmentVariable("ChocolateyInstall","Machine")	
		}
	if($Result -eq 0){
		if (!($env:ChocolateyInstall) -or !(Test-Path -Path "$env:ChocolateyInstall" -ErrorAction SilentlyContinue)){
			Write-Output "Installing Chocolatey..."
			Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
			choco install chocolatey-core.extension -y
			} Else {
				Write-Output "Chocolatey is already installed, skipping..."
			}
		}
	PromptInstallAll
	}

# installing programs
Function InstallJava {
		$Title = ""
		$Message = "To Install Java 8 hit I otherwise use S to skip"
		$Options = "&Install", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
			Write-Output "Installing Java 8..."
			choco install jre8 -y
		}else{
			Write-Warning -Message "Skipping..."
	}
}

Function InstallFirefox {
		$Title = ""
		$Message = "To Install Firefox hit I otherwise use S to skip"
		$Options = "&Install", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
			Write-Output "Installing Firefox..."
			choco install firefox -y
		}else{
			Write-Warning -Message "Skipping..."
		}
}

Function InstallDiscord {
		$Title = ""
		$Message = "To Install Discord hit I otherwise use S to skip"
		$Options = "&Install", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
			Write-Output "Installing Discord..."
			choco install discord -y
		}else{
			Write-Warning -Message "Skipping..."
		}
	}

# Works only when VirtualMachinePlatform and WSL version 1 are installed
Function InstallWSL2 {
		$Title = ""
		$Message = "To Enable WSL2 hit E or use S to skip (This works only if you have installed VirtualMachinePlatform and WSL version 1)"
		$Options = "&Enable", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
            InstallLinuxSubsystemV2
        }else{
			Write-Warning -Message "Skipping..."
    }
}

Function InstallUbuntuForWSL{
		$Title = ""
		$Message = "To Install Ubuntu as Subsystem Distro hit I or use S to skip (This works only if you have installed WSL version 1 or 2)"
		$Options = "&Install", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
            choco install wsl-ubuntu-2004
        }else{
			Write-Warning -Message "Skipping..."
    }
}

Function InstallUbuntuHere{
		$Title = ""
		$Message = "To Install Ubuntu(WSL) Here  hit I or use S to skip (This works only if you have installed Ubuntu(WSL))"
		$Options = "&Install", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
            choco install ubuntuhere
        }else{
			Write-Warning -Message "Skipping..."
    }
}

Function InstallPutty {
		$Title = ""
		$Message = "To Install Putty hit I otherwise use S to skip"
		$Options = "&Install", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
			Write-Output "Installing Putty..."
			choco install putty -y
		}else{
			Write-Warning -Message "Skipping..."
		}
}

Function InstallWinSCP {
		$Title = ""
		$Message = "To Install WinSCP hit I otherwise use S to skip"
		$Options = "&Install", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
			Write-Output "Installing WinSCP..."
			choco install winscp -y
		}else{
			Write-Warning -Message "Skipping..."
		}
}

Function InstallNeovim {
		$Title = ""
		$Message = "To Install Neovim stable hit I, otherwise use B to install the beta for support more keyboard layouts or use S to skip"
		$Options = "&Install",  "BetaInstall", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if($Result -eq 0){
			Write-Output "Installing Neovim..."
			choco install neovim -y
			choco upgrade neovim -y
		}elseif($Result -eq 1){
			Write-Output "Installing Neovim beta..."
			choco install neovim --pre -y
			choco upgrade neovim --pre -y
		}else{
			Write-Warning -Message "Skipping..."
	}
}

Function InstallPaintDotNet{
		$Title = ""
		$Message = "To Install Paint.net hit I otherwise use S to skip"
		$Options = "&Install", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
			Write-Output "Installing Paint.net..."
			choco install paint.net -y
		}else{
			Write-Warning -Message "Skipping..."
		}
}

Function InstallThunderbird {
		$Title = ""
		$Message = "To Install Thunderbird hit I otherwise use S to skip"
		$Options = "&Install", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
			Write-Output "Installing Thunderbird..."
			choco install thunderbird -y
		}else{
			Write-Warning -Message "Skipping..."
		}
}

Function InstallLinkShellExtension{
		$Title = ""
		$Message = "To Install LinkShellExtension hit I otherwise use S to skip"
		$Options = "&Install", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
			Write-Output "Installing LinkShellExtension..."
			choco install linkshellextension -y
		}else{
			Write-Warning -Message "Skipping..."
		}
}

Function InstallUninstallView {
		$Title = ""
		$Message = "To Install UninstallView hit I otherwise use S to skip"
		$Options = "&Install", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
			Write-Output "Installing UninstallView..."
			choco install uninstallview -y
		}else{
			Write-Warning -Message "Skipping..."
		}
}

Function InstallQBitTorrent {
		$Title = ""
		$Message = "To Install QBitTorrent hit I otherwise use S to skip"
		$Options = "&Install", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
			Write-Output "Installing QBitTorrent..."
			choco install qbittorrent -y
		}else{
			Write-Warning -Message "Skipping..."
		}
}

###
#Helper Functions
###

Function PromptInstallAll {
		$Title = ""
		$Message = "If you want to install every program (except Neovim) of this script choose A for AllInstall, or otherwise use D for DefaultInstall"
		$Options = "&AllInstall", "&DefaultInstall"
		
		$DefaultChoice = 1
		$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		
		if ($Result -eq 0) {
			$global:InstallEverything = 1
			Write-Output "I will install everything..."
		} Else {
			Write-Output "You chose to decide for every program..."
	}
}

Function InstallLinuxSubsystemV2 {
	if ((Get-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform").State -eq "Enabled"){
		wsl --set-default-version 2
	} Else {
		Write-Warning -Message "Cannot enable WSL2, please enable VirtualMachinePlatform!"
	}
}

# Initialize connected Drives for tweaking
function InitDrives{
	
	# Store all drives letters to use them within ShowMenu function
    if ($global:IsInitialized -eq 0){
	    Write-Verbose "Retrieving drives..." -Verbose
	
	    $global:DriveLetters = @((Get-Disk | Where-Object -FilterScript {$_.BusType -ne "USB"} | Get-Partition | Get-Volume | Where-Object -FilterScript {$null -ne $_.DriveLetter}).DriveLetter | Sort-Object)
	
	    if ($global:DriveLetters.Count -gt 1)
	    {
		    # If the number of disks is more than one, set the second drive in the list as default drive
		    $global:Default = 1
	    }
	    else
	    {
		    $global:Default = 0
	    }
		$global:IsInitialized = 1
    }
}

##############
# change drive function
##############

<#
	.SYNOPSIS
	The "Show menu" function using PowerShell with the up/down arrow keys and enter key to make a selection
	.EXAMPLE
	ShowMenu -Menu $ListOfItems -Default $DefaultChoice
	.NOTES
	Doesn't work in PowerShell ISE
#>
function ShowMenu
{
	[CmdletBinding()]
	param
	(
	[Parameter()]
	[string]
	$Title,
	
	[Parameter(Mandatory = $true)]
	[array]
	$Menu,
	
	[Parameter(Mandatory = $true)]
	[int]
	$Default
	)
	
	Write-Information -MessageData $Title -InformationAction Continue
	
	$minY = [Console]::CursorTop
	$y = [Math]::Max([Math]::Min($Default, $Menu.Count), 0)
	do
	{
		[Console]::CursorTop = $minY
		[Console]::CursorLeft = 0
		$i = 0
		foreach ($item in $Menu)
		{
			if ($i -ne $y)
			{
				Write-Information -MessageData ('  {0}. {1}  ' -f ($i+1), $item) -InformationAction Continue
			}
			else
			{
				Write-Information -MessageData ('[ {0}. {1} ]' -f ($i+1), $item) -InformationAction Continue
			}
			$i++
		}
		
		$k = [Console]::ReadKey()
		switch ($k.Key)
		{
			"UpArrow"
			{
				if ($y -gt 0)
				{
					$y--
				}
			}
			"DownArrow"
			{
				if ($y -lt ($Menu.Count - 1))
				{
					$y++
				}
			}
			"Enter"
			{
				return $Menu[$y]
			}
		}
	}
	while ($k.Key -notin ([ConsoleKey]::Escape, [ConsoleKey]::Enter))
}

# Call the desired tweak functions
$tweaks | ForEach { Invoke-Expression $_ }
