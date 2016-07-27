[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Module,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Resource
)

$currentFolder = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$moduleFolder = Join-Path $currentFolder $Module
if(-not(Test-Path $moduleFolder -ErrorAction SilentlyContinue)){
    "Creating folder $moduleFolder" | Write-Verbose
    New-Item -ItemType Directory -Path $moduleFolder -Force
}

if(-not(Test-Path "$moduleFolder\$Module.psd1")){
    "Creating module manifest" | Write-Verbose
    New-ModuleManifest -Path "$moduleFolder\$Module.psd1" `
                        -Description "Resources and modules for Package management" `
                        -CompanyName "InfoSupport" `
                        -Author "Prajeesh Prathap" `
                        -Guid ([Guid]::NewGuid() |select -ExpandProperty Guid) `
                        -FunctionsToExport "*" `
                        -PowerShellVersion "4.0" `
                        -ClrVersion "4.0" `
                        -ModuleVersion "1.0.0" `
                        -Copyright "(c) 2010-2016 Prajeesh Prathap, All rights reserved." `
                        -CmdletsToExport "*"                 
}

$moduleName = New-xDscResourceProperty -Name 'Module' -Type String -Attribute Key -Description 'Module name to install using powershell packagemanager'
$version = New-xDscResourceProperty -Name 'Version' -Type String -Attribute Write -Description 'Required version of the module'
$ensure = New-xDscResourceProperty -Name 'Ensure' -Type String -ValidateSet 'Present', 'Absent' -Attribute Write -Description 'Ensures the module is present or absent in the system'

"Creating the resource $Resource" | Write-Verbose
New-xDscResource -ModuleName $Module -Name $Resource -Property $moduleName, $version, $ensure -Path $currentFolder -Force