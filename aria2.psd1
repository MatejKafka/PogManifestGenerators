@{
    ListVersions = {
        Get-GitHubRelease aria2/aria2 `
            | ? {$_.tag_name.StartsWith("release-")} `
            | % {
                # sometimes there's a build1 and build2, select the higher numbered one
                $Asset = $_.assets | ? name -like "aria2-*-win-64bit-build*.zip" | select -Last 1
                if ($Asset) {
                    return @{
                        Version = $_.tag_name.Substring(8)
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