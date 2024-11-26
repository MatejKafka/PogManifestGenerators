@{
    ListVersions = {
        Get-GitHubRelease mozilla/sccache `
            | ? {$_.tag_name.StartsWith("v")} `
            | % {
                $Asset = $_.assets | ? {$_.name -like "sccache-*-x86_64-pc-windows-msvc.zip"}
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