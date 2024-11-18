@{
    ListVersions = {
        Get-GitHubRelease microsoft/git `
            | ? {$_.tag_name.StartsWith("v")} `
            | % {
                $Asset = $_.assets | ? name -like "PortableGit-*-64-bit.7z.exe"
                if ($Asset) {
                    return @{
                        Version = $_.tag_name.Substring(1)
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