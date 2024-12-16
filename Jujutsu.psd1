@{
    ListVersions = {
        Get-GitHubRelease martinvonz/jj `
            | ? {$_.tag_name.StartsWith("v")} `
            | ? tag_name -notin "v0.3.0", "v0.3.1", "v0.3.2", "v0.3.3", "v0.5.0" `
            | % {
                $ExeAsset = $_.assets | ? {$_.name -like "jj-v*-x86_64-pc-windows-msvc.zip"}
                if (-not $ExeAsset) {
                    throw "Jujutsu: Missing archive for version '$($_.tag_name)'."
                }

                return @{
                    Version = $_.tag_name.Substring(1)
                    ExeUrl = $ExeAsset.browser_download_url
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