@{
    ListVersions = {
        Get-GitHubRelease rust-lang/rust-analyzer `
            | ? {$_.tag_name -like "????-??-??"} `
            | % {
                $ExeAsset = $_.assets | ? {$_.name -eq "rust-analyzer-x86_64-pc-windows-msvc.zip"}
                if ($ExeAsset) {
                    return @{
                        Version = $_.tag_name.Replace("-", ".")
                        Url = $ExeAsset.browser_download_url
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