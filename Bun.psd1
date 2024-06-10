@{
    ListVersions = {
        Get-GitHubRelease oven-sh/bun `
            | ? {$_.tag_name.StartsWith("bun-v")} `
            | % {
                $Asset = $_.assets | ? name -eq "bun-windows-x64.zip"
                if ($Asset) {
                    return @{
                        Version = $_.tag_name.Substring(5)
                        Asset = $Asset
                        HashUrl = ($_.assets | ? name -eq "SHASUMS256.txt").browser_download_url
                    }
                }
            }
    }

    Generate = {
        return [ordered]@{
            Version = $_.Version
            Url = $_.Asset.browser_download_url
            Hash = Get-HashFromChecksumFile $_.HashUrl $_.Asset.name
        }
    }
}