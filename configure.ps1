$tweaks = @(
	"InstallChoco",
    "InstallFirefox",
    "InstallDiscord",
    "InstallJava"
)

$global:IsInitialized = 0
$global:Default = 0
$global:DriveLetters

Function InstallChoco {
	$Title = ""
	$Message = "To Install Chocolatey hit I or R to also change the installation drive"
	$Options = "&Install", "&RelocateAndInstall"
	Write-Output "About to install Chocolatey"
    Write-Warning -Message "This is required for base programs"
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
			Write-Output "Installing Chocolatey..."
			Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
			choco install chocolatey-core.extension -y
		}
	}

Function InstallJava {
		$Title = ""
		$Message = "To Install Java hit I otherwise use S to skip"
		$Options = "&Install", "&Skip"
		
		$DefaultChoice = 1
		$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		if($Result -eq 0){
			Write-Output "Installing Java..."
			choco install jre8 -y
		}else{
			Write-Warning -Message "Skipping..."
	}
}

Function InstallFirefox {
		$Title = ""
		$Message = "To Install Firefox hit I otherwise use S to skip"
		$Options = "&Install", "&Skip"
		
		$DefaultChoice = 1
		$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		if($Result -eq 0){
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
		
		$DefaultChoice = 1
		$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		if($Result -eq 0){
			Write-Output "Installing Discord..."
			choco install discord -y
		}else{
			Write-Warning -Message "Skipping..."
		}
	}

# Initialize connected Drives, for further tweaking
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