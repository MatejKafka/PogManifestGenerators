@{
    ListVersions = {
        Get-GitHubRelease restic/restic `
            | ? {$_.tag_name.StartsWith("v")} `
            | ? {[Pog.PackageVersion]$_.tag_name.Substring(1) -ge "0.8.0"} <# no support for --cache-dir #> `
            | % {
                $Asset = $_.assets | ? {$_.name -like "restic_*_windows_amd64.zip"}
                $ChecksumAsset = $_.assets | ? name -eq "SHA256SUMS"
                if ($Asset -and $ChecksumAsset) {
                    return @{
                        Version = $_.tag_name.Substring(1)
                        Url = $Asset.browser_download_url
                        FileName = $Asset.name
                        ChecksumUrl = $ChecksumAsset.browser_download_url
                    }
                }
            }
    }

    Generate = {
        return [ordered]@{
            Version = $_.Version
            Url = $_.Url
            Hash = Get-HashFromChecksumFile $_.ChecksumUrl $_.FileName
        }
    }
}