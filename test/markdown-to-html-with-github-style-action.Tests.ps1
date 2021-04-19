$global:NL = [System.Environment]::NewLine

Describe 'In Place Conversion' {
    It 'README' {
        Get-Content -Path "test\files\README.html" -Raw | Should -Not -BeNullOrEmpty
    }
    It 'CHANGELOG' {
        Get-Content -Path "test\files\CHANGELOG.html" -Raw | Should -Not -BeNullOrEmpty
    }
    It 'doc1' {
        Get-Content -Path "test\files\docs\doc1.html" -Raw | Should -Not -BeNullOrEmpty
    }
}

Describe 'outputpath' {
    It 'README' {
        Get-Content -Path "test\out1\README.html" -Raw | Should -Not -BeNullOrEmpty
    }
    It 'CHANGELOG' {
        Get-Content -Path "test\out1\CHANGELOG.html" -Raw | Should -Not -BeNullOrEmpty
    }
    It 'doc1' {
        Get-Content -Path "test\out1\doc1.html" -Raw | Should -Not -BeNullOrEmpty
    }
}

Describe 'matchpathstructure' {
    It 'README' {
        Get-Content -Path "test\out2\test\files\README.html" -Raw | Should -Not -BeNullOrEmpty
    }
    It 'CHANGELOG' {
        Get-Content -Path "test\out2\test\files\CHANGELOG.html" -Raw | Should -Not -BeNullOrEmpty
    }
    It 'doc1' {
        Get-Content -Path "test\out2\test\files\docs\doc1.html" -Raw | Should -Not -BeNullOrEmpty
    }
}