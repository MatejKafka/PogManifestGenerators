@{
    ListVersions = {
        Get-GitHubRelease alacritty/alacritty `
            | ? {$_.tag_name.StartsWith("v")} `
            | % {
                $ExeAsset = $_.assets | ? {$_.name -like "Alacritty-v*-portable.exe"}
                if ($ExeAsset) {
                    return @{
                        Version = $_.tag_name.Substring(1)
                        ExeUrl = $ExeAsset.browser_download_url
                    }
                }
            }
    }

    Generate = {
        return [ordered]@{
            Version = $_.Version
            Url = $_.ExeUrl
            Hash = Get-UrlHash $_.ExeUrl
        }
    }
}