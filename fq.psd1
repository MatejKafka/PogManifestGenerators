@{
    ListVersions = {
        Get-GitHubRelease wader/fq `
            | ? {$_.tag_name.StartsWith("v")} `
            | % {
                $Asset = $_.assets | ? {$_.name -like "fq_*_windows_amd64.zip"}
                $ChecksumAsset = $_.assets | ? name -eq "checksums.txt"
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