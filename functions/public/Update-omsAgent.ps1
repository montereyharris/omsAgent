#Requires -Version 5.0

function Update-OmsAgent
{
	<#
		.Synopsis
			Update the OMS agent on remote computers.
		.DESCRIPTION
			Either downloads the installer from a URL or copies the installer via the powershell session. Can detected if a previous version is installed and skip if so. If allready installed WorkSpaceId and WorkSpaceKey added to previous install. Doesn't detect invalid workspace IDs or Keys.
		.EXAMPLE
			Update-OmsAgent -sourcePath 'c:\MMASetup-AMD64.exe'  -Verbose
		.EXAMPLE
			Update-OmsAgent -computerName <computerName>  -Verbose
		.NOTES
			Written by ben taylor and Monty Harris
			Version 1.0, 25.07.2017
	#>
	[CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'Low', DefaultParameterSetName='downloadOMS')]
	[OutputType([String])]
	Param (
		[Parameter(Mandatory = $false, Position = 0, ValueFromPipeline=$True, valuefrompipelinebypropertyname=$true)]
		[ValidateNotNullOrEmpty()]
		[Alias('IPAddress', 'Name')]
		[string[]]
		$computerName = $env:COMPUTERNAME,

		[Parameter(Mandatory=$true, ParameterSetName='downloadOms')]
		[ValidateNotNullOrEmpty()]
		[string]
		$downloadURL = 'http://download.microsoft.com/download/0/C/0/0C072D6E-F418-4AD4-BCB2-A362624F400A/MMASetup-AMD64.exe',

		[Parameter(ParameterSetName='localOMS')]
		[ValidateScript({Test-Path $_ })]
		[string]
		$sourcePath,

		[Parameter(Mandatory = $false)]
		[Parameter(ParameterSetName='downloadOMS')]
		[Parameter(ParameterSetName='localOMS')]
		[System.Management.Automation.PSCredential]
		[System.Management.Automation.Credential()]
		$Credential
	)

	Begin
	{
		$commonSessionParams = @{
			ErrorAction = 'Stop'
		}

		If ($PSBoundParameters['Credential'])
		{
			$commonSessionParams.Credential = $Credential
		}
	}
	Process
	{
		forEach ($computer in $computerName)
		{
			try
			{

				Write-Verbose "[$(Get-Date -Format G)] - $computer - Creating Remote PS Session"
				$psSession = New-PSSession -ComputerName $computer -EnableNetworkAccess @commonSessionParams

				Write-Verbose "[$(Get-Date -Format G)] - $computer - Checking if OMS is Installed"

				$orginalAgent = Get-omsAgentInternal -computerName $computer -session $psSession
				if(($orginalAgent))
				{
					If ($Pscmdlet.ShouldProcess($computer, 'Update OMS Agent'))
					{
						 $path = Invoke-Command -Session $pssession -ScriptBlock {
							$path = Join-Path $ENV:temp "MMASetup.exe"

							# Check if file exists and if so remove
							if(Test-Path $path)
							{
								Remove-Item $path -force -Confirm:$false
							}

							$path
						 }

						if($PSBoundParameters.sourcePath) # Check for source path
						{
							Write-Verbose "[$(Get-Date -Format G)] - $computer - Copying files over powershell session"
							Copy-Item -Path $sourcePath -Destination  $path -ToSession $psSession -Force
						}
						else
						{
							Write-Verbose "[$(Get-Date -Format G)] - $computer - Trying to download new installer from URL - $downloadURL"
							Invoke-Command -Session $psSession -ScriptBlock {
								Invoke-WebRequest $USING:downloadURL -OutFile $USING:path -ErrorAction Stop | Out-Null
							} -ErrorAction Stop
						}


						Write-Verbose "$computer - Trying to Update OMS..."
						$installString = $path + ' /Q:A /R:N /C:"setup.exe /qn AcceptEndUserLicenseAgreement=1"'

						$installSuccess = Invoke-Command -Session $psSession -ScriptBlock {
							Get-service HealthService|Stop-Service
							cmd.exe /C $USING:installString
							$LASTEXITCODE
						} -ErrorAction Stop

						Write-Verbose "[$(Get-Date -Format G)] - $computer - $installSuccess"

						if($installSuccess -eq 3010)
						{
							Write-Verbose "$computer - OMS updated correctly based on the exit code"
							Write-Verbose "$computer - Restarting HealthService"
							Invoke-Command -Session $psSession -ScriptBlock {
										Get-service HealthService|Start-Service
												} -ErrorAction Stop

						}
						Elseif($installSuccess -ne 0)
						{
							Invoke-Command -Session $psSession -ScriptBlock {
										Get-service HealthService|Start-Service
												} -ErrorAction Stop
							Write-Verbose "$computer - Restarting HealthService"
							Write-Error "$computer - OMS didn't update correctly based on the exit code"


						}
						else
						{
							if((Get-omsAgentInternal -computerName $computer -session $psSession).displayverison -gt $orginalAgent.displayverison)
							{
								Write-Verbose "[$(Get-Date -Format G)] - $computer - OMS Updated correctly"
								Invoke-Command -Session $psSession -ScriptBlock {
										Get-service HealthService|Start-Service
												} -ErrorAction Stop
							}
							else
							{
								Write-Error "[$(Get-Date -Format G)] - $computer - OMS didn't install correctly based on the exit code"
							}
						}
					}
				}
				else
				{
					Write-Error "[$(Get-Date -Format G)] - $computer - OMS Agent not installed so skipping."
				}
			}
			catch
			{
				Write-Error $_
			}
			Finally
			{
				Write-Verbose "[$(Get-Date -Format G)] - $computer - Tidying up install files\sessions if needed"

				if($null -ne $psSession)
				{
					try
					{
						Invoke-Command -Session $pssession -ScriptBlock {
							if(Test-Path $USING:path)
							{
								Remove-Item $USING:path -force -Confirm:$false
							}
						} -ErrorAction Stop
					}
					catch
					{
						Write-Verbose "[$(Get-Date -Format G)] - $computer - Nothing to tidy up"
					}

					Remove-PSSession $psSession -whatif:$false -Confirm:$false
				}
			}
		}
	}
}