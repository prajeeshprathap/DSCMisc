[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Module,


    [Parameter]
    [ValidateNotNullOrEmpty()]
    [string]
    $Resource
)

$currentFolder = Split-Path -Parent -Path $PSCmdlet.