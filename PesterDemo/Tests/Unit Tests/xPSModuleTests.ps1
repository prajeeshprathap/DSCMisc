$currentFolder = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition


$Module = 'xPSPackage'
$DSCResource = 'xPSModule'
$moduleFolder = "$currentFolder\..\..\Resources\$Module"

Describe "$DSCResource Test-TargetResource"{
    
    Copy-Item "$moduleFolder\DSCResources\$DSCResource\$DSCResource.psm1" TestDrive:\script.ps1 -Force
    Mock Get-Module { return "$Module" }
    Mock Export-ModuleMember {return $true}

    . "TestDrive:\script.ps1"
    
    Context "CChoco module is installed and Ensure is passed as Present"{
        It "Should return true"{
            Test-TargetResource -Module "CChoco" -Ensure "Present" | Should Be $True
        }
    }
}

Describe "$DSCResource Get-TargetResource"{

    Copy-Item "$moduleFolder\DSCResources\$DSCResource\$DSCResource.psm1" TestDrive:\script.ps1 -Force
    Mock Get-Module {
        $moduleDetails = New-Object psobject -Property @{
                            Name = 'CChoco'
                            ModuleType = 'Manifest'
                            Version = '1.0.0'
                        }
        return $moduleDetails                            
    }
    Mock Export-ModuleMember {return $true}

    . "TestDrive:\script.ps1"

    Context "CChoco module is installed"{
        It "Should return hashtable with proper values"{
            $value = Get-TargetResource -Module 'cChoco'
            $value.Module | Should Be 'cChoco'
            $value.Ensure | Should Be 'Present'
        }
    }
}

Describe "$DSCResource Set-TargetResource"{

    Copy-Item "$moduleFolder\DSCResources\$DSCResource\$DSCResource.psm1" TestDrive:\script.ps1 -Force
    Mock Export-ModuleMember {return $true}

    . "TestDrive:\script.ps1"

    Context "Ensure is passed as Present"{
        Mock Install-Module -Verifiable
        It "Should call install module"{
            Set-TargetResource -Module "CChoco" -Ensure 'Present'
            Assert-VerifiableMocks
        }
    }
    Context "Ensure is passed as Present and Version as 2.0.0"{
        Mock Install-Module -Verifiable -ParameterFilter {
            $Version -eq '2.0.0'
        }
        It "Should call install module with version 2.0.0"{
            Set-TargetResource -Module "CChoco" -Ensure 'Present' -Version '2.0.0'
            Assert-VerifiableMocks 
        }
    }
    Context "Ensure is passed as Absent"{        
        Mock Uninstall-Module -Verifiable
        It "Should call Remove module"{
            Set-TargetResource -Module "CChoco" -Ensure 'Absent'
            Assert-VerifiableMocks 
        }
    }
}
