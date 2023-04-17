#requires -modules AnyPackageDsc

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments',
    '',
    Justification = 'Does not work with Pester scopes.')]
param()

Describe 'Resource' {
    Context 'Get-DscResource' {
        It 'should return <_> resource' -ForEach 'Source' {
            Get-DscResource -Name $_ -Module AnyPackageDsc |
                Select-Object -ExpandProperty Name |
                Should -Be $_
        }
    }
}
