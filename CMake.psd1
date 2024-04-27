@{
    ListVersions = {
        Get-GitHubRelease Kitware/CMake `
            | ? {$_.tag_name.StartsWith("v")} `
            | % {
                $Asset = $_.assets | ? name -like "cmake-*-windows-x86_64.zip"
                $ChecksumAsset = $_.assets | ? name -like "cmake-*-SHA-256.txt"
                if ($Asset) {
                    return @{
                        Version = $_.tag_name.Substring(1)
                        Url = $Asset.browser_download_url
                        FileName = $Asset.name
                        ChecksumUrl = if ($ChecksumAsset) {$ChecksumAsset.browser_download_url}
                    }
                }
            }
    }

    Generate = {
        return [ordered]@{
            Version = $_.Version
            Url = $_.Url
            Hash = if (-not $_.ChecksumUrl) {
                Write-Information "Computing hash locally for CMake version '$($_.Version)'..."
                Get-UrlHash $_.Url
            } else {
                Get-HashFromChecksumFile $_.ChecksumUrl $_.FileName
            }
        }
    }
}