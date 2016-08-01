function Demo {
    ShouldMock
    return $true
}


function ShouldMock{
    Write-Host "This will not be called"
}