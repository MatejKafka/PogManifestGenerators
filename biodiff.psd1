@{
    ListVersions = {
        Get-GitHubRelease 8051Enthusiast/biodiff `
            | ? {$_.tag_name.StartsWith("v")} `
            | % {
                $Version = $_.tag_name.Substring(1)
                if ([Pog.PackageVersion]$Version -lt "1.0.3") {
                    return
                }

                $Asset = $_.assets | ? name -like "biodiff-windows-*.zip"
                if ($Asset) {
                    return @{
                        Version = $Version
                        Url = $Asset.browser_download_url
                    }
                }
            }
    }

    Generate = {
        return [ordered]@{
            Version = $_.Version
            Url = $_.Url
            Hash = Get-UrlHash $_.Url
        }
    }
}