# FIXME: versions since 0.13.0 switched to a .toml config file, this generator will not list them
@{
    ListVersions = {
        Get-GitHubRelease alacritty/alacritty `
            | ? {$_.tag_name.StartsWith("v")} `
            | % {
                $ExeAsset = $_.assets | ? {$_.name -like "Alacritty-v*-portable.exe"}
                $ConfigAsset = $_.assets | ? {$_.name -eq "alacritty.yml"}
                if ($ExeAsset -and $ConfigAsset) {
                    return @{
                        Version = $_.tag_name.Substring(1)
                        ExeUrl = $ExeAsset.browser_download_url
                        ConfigUrl = $ConfigAsset.browser_download_url
                    }
                }
            }
    }

    Generate = {
        return [ordered]@{
            Version = $_.Version
            
            ExeUrl = $_.ExeUrl
            ExeHash = Get-UrlHash $_.ExeUrl

            ConfigUrl = $_.ConfigUrl
            ConfigHash = Get-UrlHash $_.ConfigUrl
        }
    }
}