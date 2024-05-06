@{
    ListVersions = {
        Get-GitHubRelease syncthing/syncthing `
            | ? {$_.tag_name.StartsWith("v")} `
            | % {
                $Asset = $_.assets | ? {$_.name -like "syncthing-windows-amd64-v*.zip"}
                $ChecksumAsset = $_.assets | ? name -eq "sha256sum.txt.asc"
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