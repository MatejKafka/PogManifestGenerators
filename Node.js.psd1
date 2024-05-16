@{
    ListVersions = {
        Invoke-WebRequest https://nodejs.org/dist/ `
            | % Links `
            | ? href -match "^v([\d\.]+)/$" `
            | % {$Matches[1]} `
            | ? {[Pog.PackageVersion]$_ -ge "6.2.1"} <# first version with archives, previous versions only had .msi #>
    }

    Generate = {
        [ordered]@{
            Version = $_
            Url = "https://nodejs.org/dist/v${_}/node-v${_}-win-x64.7z"
            Hash = Get-HashFromChecksumFile "https://nodejs.org/dist/v${_}/SHASUMS256.txt" "node-v${_}-win-x64.7z"
        }
    }
}