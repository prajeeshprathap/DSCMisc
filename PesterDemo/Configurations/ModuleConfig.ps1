Configuration PSModuleConfiguration{
    Import-DSCResource -Module xPSPackage
    Node 'localhost'{
        xPSModule Chocolatey{
            Module = 'cChoco'
            Ensure = 'Present'
        }
        xPSModule Octopus{
            Module = 'Octopus-Cmdlets'
            Ensure = 'Present'
        }
        xPSModule VSTS{
            Module = 'VSTS'
            Ensure = 'Present'
        }
    }
}

PSModuleConfiguration
Start-DSCConfiguration .\PSModuleConfiguration -Wait -Verbose