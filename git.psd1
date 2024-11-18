@{
    ListVersions = {
        Get-GitHubRelease git-for-windows/git `
            | ? {$_.tag_name -match "^v(.*)\.windows\.\d+$"} `
            | % {
                $Asset = $_.assets | ? name -like "PortableGit-*-64-bit.7z.exe"
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