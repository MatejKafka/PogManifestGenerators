@{
    ListVersions = {
        Get-GitHubRelease jftuga/less-Windows `
            | ? tag_name -match "(?:^|less-)v([0-9.]+)" `
            | % {
                $Asset = $_.assets | ? name -eq "less-x64.zip"
                if ($Asset) {
                    return @{
                        Version = $Matches[1]
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