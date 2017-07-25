if(-not (Get-Module omsAgent))
{
	$here = (Split-Path -Parent $MyInvocation.MyCommand.Path).Replace('tests\functions\public', '')
	Import-Module (Join-Path $here 'omsAgent.psd1') 
}

InModuleScope -moduleName omsAgent {
    Describe 'Update-omsAgentWorkSpaceKey' {
        BeforeAll {
            Mock Invoke-Command {}
        }

        Context 'Logic' {
            it 'Parameters' {
                {Update-omsAgentWorkSpaceKey -workspa 'test' -workssey 'test' -ErrorAction Stop} | Should Throw
            }

            it 'WorkSpace Does Not Exist' {
                Mock Get-omsAgentWorkSpaceInternal { $null }

                Update-omsAgentWorkSpaceKey -workspaceid 'test' -workspacekey 'test' -ErrorAction SilentlyContinue | Out-Null

                Assert-MockCalled Invoke-Command -Exactly 0 -Scope It
            }

            it 'WorkSpace Does Exists' {
                Mock Get-omsAgentWorkSpaceInternal { $true }

                Update-omsAgentWorkSpaceKey -workspaceid 'test' -workspacekey 'test' -ErrorAction SilentlyContinue | Out-Null

                Assert-MockCalled Invoke-Command -Exactly 1 -Scope It     
            }

            it 'Creates\Removes A PsSession Without Whatif' {
                Mock New-PSSession { 'sessionData' }
                Mock Remove-PSSession {}
                Mock Get-omsAgentWorkSpaceInternal { $null }

                Update-omsAgentWorkSpaceKey -workspaceid 'test' -workspacekey 'test' -ErrorAction SilentlyContinue | Out-Null

                Assert-MockCalled New-PSSession -Exactly 1 -Scope It  
                Assert-MockCalled Remove-PSSession -Exactly 1 -Scope It  
            }
        }
    }
}