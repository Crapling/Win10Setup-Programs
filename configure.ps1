# for more information about this script refer to my Win10Setup-Debloat Script: https://github.com/Crapling/Win10Setup-Debloat

$tweaks = @(
	"InstallChoco",
	"InstallNeovim",
    "InstallFirefox",
    "InstallDiscord",
    "InstallJava",
	"InstallWSL2",
	"InstallUbuntuForWSL",
    "InstallGit",
	"InstallPutty",
	"InstallWinSCP",
	"InstallPaintDotNet",
	"InstallThunderbird",
	"InstallLinkShellExtension",
	"InstallUninstallView",
	"InstallQBitTorrent",
    "FinishedInstall"
)

$global:IsInitialized = 0
$global:Default = 0
$global:InstallEverything = 0
$global:DriveLetters

# installing Chocolatey and provide the option to move the default install drive
Function InstallChoco {
$Title = ""
	$Message = "To Install Chocolatey hit I or R to also change the installation drive"
	$Options = "&Install", "&RelocateAndInstall", "&Skip"
	Write-Output "About to install Chocolatey"
    Write-Warning -Message "This is required for base programs"
	$DefaultChoice = 1
	$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
    $ChocoPath=":\Program Files (x86)\Chocolatey"
    $ChocoEnv="ChocolateyInstall"
    $ChocoToolsEnv="ChocolateyToolsLocation"
    $DoChocoInstall=1
    $IsChocoInPath=Test-Path -Path "$env:ChocolateyInstall" -ErrorAction SilentlyContinue

	if($Result -le 1){
		if($Result -eq 1){
        initDrives
		$Title = "`nSelect the drive where Chocolatey should be installed"
		$SelectedDrive = ShowMenu -Title $Title -Menu $global:DriveLetters -Default $global:Default
		if ("$env:ChocolateyInstall" -AND $SelectedDrive -ne $env:ChocolateyInstall.Substring(0,1) -and !(Test-Path -Path "${SelectedDrive}$ChocoPath" -ErrorAction SilentlyContinue) -and $IsChocoInPath) {
            Write-Output "Chocolatey is installed on another drive..."
            Write-Output "Moving Chocolatey installation to selected drive..."
			Move-Item -force "$env:ChocolateyInstall" "${SelectedDrive}:\Program Files (x86)"
            $DoChocoInstall=0
            }
         }
            if(!($SelectedDrive)){
                $SelectedDrive=((Get-Location).Path.Substring(0,1))
            }
        
		    Write-Output "Parsing Environment Variable..."
            [System.Environment]::SetEnvironmentVariable("$ChocoToolsEnv", "${SelectedDrive}$ChocoPath\tools" ,[System.EnvironmentVariableTarget]::Machine)
            [System.Environment]::SetEnvironmentVariable("$ChocoEnv","${SelectedDrive}$ChocoPath",[System.EnvironmentVariableTarget]::Machine)
            # reinit environment variable
		    $env:ChocolateyInstall = [System.Environment]::GetEnvironmentVariable("$ChocoEnv","Machine")
            $env:ChocolateyToolsLocation = [System.Environment]::GetEnvironmentVariable("$ChocoToolsEnv","Machine")
                
            if(Test-Path -Path "${SelectedDrive}$ChocoPath"){
                Write-Output "Chocolatey is already installed, skipping installation..."
                $DoChocoInstall=0
            }

            if($DoChocoInstall -eq 1){
                Write-Output "Installing Chocolatey..."
			    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
			    choco install chocolatey-core.extension -y
            }
		}else{
            if($IsChocoInPath){
                Write-Output "Chocolatey is already installed, proceeding to the next step..."
            }else{
                Write-Output "Chocolatey core dependency program install skipped, exiting..."
                Start-Sleep -s 3
                FinishedInstall
                Exit
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

Function InstallNotion {
		$Title = ""
		$Message = "To Install Notion hit I otherwise use S to skip"
		$Options = "&Install", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
			Write-Output "Installing Notion..."
			choco install notion -y
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
            choco install wsl-ubuntu-2004 -y
        }else{
			Write-Warning -Message "Skipping..."
    }
}

# install git with posh-git
Function InstallGit{
		$Title = ""
		$Message = "To Install Git hit I or use S to skip"
		$Options = "&Install", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
            choco install git.install --params "/GitAndUnixToolsOnPath /WindowsTerminal /NoShellIntegration /NoGuiHereIntegration /NoShellHereIntegration" -y
            PromptInstallPoshGit
        }else{
			Write-Warning -Message "Skipping..."
    }
}

Function PromptInstallPoshGit{
		$Title = ""
		$Message = "To Install posh-git hit I or use S to skip"
		$Options = "&Install", "&Skip"
		$Result = 0
		$DefaultChoice = 1
		if (!($global:InstallEverything)){
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		}
		if(($Result -eq 0) -or $global:InstallEverything){
            choco install poshgit -y
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
		$Options = "&Install",  "&BetaInstall", "&Skip"
		$Result = 0
		$DefaultChoice = 2
		
        $Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		
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

# enable wsl2
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

Function FinishedInstall{
    Write-Output  "`nFinished script, you can check for errors and close the window`n"
}

# Call the desired tweak functions
$tweaks | ForEach { Invoke-Expression $_ }
