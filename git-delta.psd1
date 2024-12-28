@{
    ListVersions = {
        Get-GitHubRelease dandavison/delta | % {
            $Asset = $_.assets | ? name -like "delta-*-x86_64-pc-windows-msvc.zip"
            if ($Asset) {
                return @{
                    Version = $_.tag_name
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