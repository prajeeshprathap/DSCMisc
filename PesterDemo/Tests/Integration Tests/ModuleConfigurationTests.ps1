Describe "Installation of modules from PowerShellGet"{ 
    Context "PSModuleConfiguration is applied on the system"{
        It "Should have installed CChoco module"{
            Get-Module -Name "cChoco" -ListAvailable | Should Not BeNullOrEmpty
        }
        It "Should have installed Octopus cmdlets module"{
            Get-Module -Name "Octopus-Cmdlets" -ListAvailable | Should Not BeNullOrEmpty
        }
        It "Should have installed VSTS module"{
            Get-Module -Name "VSTS" -ListAvailable | Should Not BeNullOrEmpty
        }
    }
}