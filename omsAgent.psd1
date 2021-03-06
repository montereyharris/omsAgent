#
# Module manifest for module 'omsAgent'
#
# Generated by: Ben Taylor
#
# Generated on: 30/07/2016 18:07
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'omsAgent.psm1'

# Version number of this module.
ModuleVersion = '1.3'

# ID used to uniquely identify this module
GUID = '39daa9a5-8a75-4461-8d95-ccd7717c3c65'

# Author of this module
Author = 'Ben Taylor'

# Company or vendor of this module
CompanyName = 'Ben Taylor Work'

# Copyright statement for this module
Copyright = '(c) 2016 Ben Taylor. All rights reserved.'

# Description of the functionality provided by this module
Description = 'A PowerShell module to aide with deployment and management of OMS agents on remote computers.'

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module
FunctionsToExport = 'Get-omsAgentWorkSpace', 'Get-omsAgent', 'Add-omsAgentWorkSpace', 'Remove-omsAgentWorkSpace', 'Update-omsAgentWorkSpaceKey', 'Install-omsAgent', 'Uninstall-omsAgent', 'Get-omsAgentProxy', 'Remove-omsAgentProxy', 'Add-omsAgentProxy', 'Install-OmsDependencyAgent', 'Get-omsDependencyAgent', 'Uninstall-omsDependencyAgent','Update-omsAgent'

# Cmdlets to export from this module
CmdletsToExport = ''

# Variables to export from this module
VariablesToExport = ''

# Aliases to export from this module
AliasesToExport = ''

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('OMS', 'OMSAgent', 'OperationsManagementSuite', 'OperationsManagementSuiteAgent')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/bentaylorwork/omsAgent/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/bentaylorwork/omsAgent/'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}