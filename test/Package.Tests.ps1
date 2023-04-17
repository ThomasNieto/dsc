#requires -modules AnyPackageDsc

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments',
    '',
    Justification = 'Does not work with Pester scopes.')]
param()

Describe 'Resource' {
    Context 'Get-DscResource' {
        It 'should return <_> resource' -ForEach 'Package' {
            Get-DscResource -Name $_ -Module AnyPackageDsc |
                Select-Object -ExpandProperty Name |
                Should -Be $_
        }
    }

    Context 'Test Method' {
        BeforeDiscovery {
            $tests = @(
                @{
                    Result   = $false
                    Property = @{
                        Name     = 'AnyPackage'
                        Provider = 'AnyPackage.PowerShellGet\PowerShellGet'
                        Version  = '*'
                        Ensure   = 'Absent'
                    }
                }
                @{
                    Result   = $true
                    Property = @{
                        Name     = 'broke'
                        Provider = 'AnyPackage.PowerShellGet\PowerShellGet'
                        Version  = '*'
                        Ensure = 'Absent'
                    }
                }
                @{
                    Result   = $false
                    Property = @{
                        Name     = 'PowerShellGet'
                        Provider = 'AnyPackage.PowerShellGet\PowerShellGet'
                        Version  = '*'
                    }
                }
                @{
                    Result   = $true
                    Property = @{
                        Name       = 'PowerShellGet'
                        Provider   = 'AnyPackage.PowerShellGet\PowerShellGet'
                        Version    = '*'
                        Prerelease = $true
                    }
                }
                @{
                    Result   = $true
                    Property = @{
                        Name       = 'AnyPackage'
                        Provider   = 'AnyPackage.PowerShellGet\PowerShellGet'
                        Version    = '*'
                        Latest     = $true
                    }
                }
                @{
                    Result   = $true
                    Property = @{
                        Name       = 'AnyPackage'
                        Provider   = 'AnyPackage.PowerShellGet\PowerShellGet'
                        Version    = '*'
                        Source     = 'PSGallery'
                    }
                }
                @{
                    Result   = $false
                    Property = @{
                        Name       = 'AnyPackage'
                        Provider   = 'AnyPackage.PowerShellGet\PowerShellGet'
                        Version    = '*'
                        Source     = 'broke'
                    }
                }
            )
        }

        It 'should return <Result> for <Property.Name>' -ForEach $tests {
            $params = @{
                Name       = 'Package'
                ModuleName = 'AnyPackageDsc'
                Method     = 'Test'
                Property   = $Property
            }

            Invoke-DscResource @params |
                Select-Object -ExpandProperty InDesiredState |
                Should -Be $Result
        }
    }
}
