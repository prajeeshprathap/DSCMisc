function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Module
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."


    $moduleDetails = Get-Module -Name $Module -ListAvailable -ErrorAction SilentlyContinue
    $present = $moduleDetails -ne $null
    $presentValue = 'Absent'
    if($present){
        $presentValue = 'Present'
    }
    $returnValue = @{
        Module = $moduleDetails | Select -expand Name
        Version = $module | Select Version -ErrorAction SilentlyContinue | Format-Table -HideTableHeaders -ErrorAction SilentlyContinue | Out-String -ErrorAction SilentlyContinue
        Ensure = $presentValue
    }

    return $returnValue
    
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Module,

        [System.String]
        $Version,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure
    )

    $present = $ensure -eq 'Present'
    if($present){
        if([string]::IsNullOrWhiteSpace($Version)){
            "Installing module $Module" | Write-Verbose
            Install-Module -Name $Module -Force -Verbose
        }
        else{
            "Installing module $Module with version $Version" | Write-Verbose
            Install-Module -Name $Module -RequiredVersion $Version -Force -Verbose
        }
    }
    else {
        if([string]::IsNullOrWhiteSpace($Version)){
            "Uninstalling module $Module" | Write-Verbose
            Uninstall-Module -Name $Module -Force -AllVersions
        }
        else{
            "Uninstalling module $module with version $Version" | Write-Verbose
            Uninstall-Module -Name $Module -Force -RequiredVersion $Version
        }
    }

    #Include this line if the resource requires a system reboot.
    #$global:DSCMachineStatus = 1
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Module,

        [System.String]
        $Version,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure
    )

    
    $result = (Get-Module -ListAvailable -Name $Module -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) -ne $null
    $present = $Ensure -eq 'Present'
    if($result){
        if($present){
            "The module $Module already exists. No action needed" | Write-Verbose
            return $true
        }
        else {
            "The module $Module exist. This will be removed" | Write-Verbose
            return $false
        }
    }
    else{
        if($present){
            "The module $Module does not exist. This will be installed" | Write-Verbose
            return $false
        }
        else{
            "The module $Module does not exist. No action needed" | Write-Verbose
            return $true
        }
    }
}


Export-ModuleMember -Function *-TargetResource

