$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Demo" {
    Mock ShouldMock{
        Write-Host "This is a mock"
    }
    It "does something useful" {
        Demo | Should Be $true
        Assert-MockCalled ShouldMock
    }
}
