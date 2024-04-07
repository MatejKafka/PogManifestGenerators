@{
    ListVersions = {
        return Invoke-RestMethod -UseBasicParsing -FollowRelLink "https://api.github.com/repos/ccache/ccache/releases" `
            | % {$_} <# split single array to separate pipeline items #> `
            | ? {$_.tag_name.StartsWith("v")} `
            | % {
                $Asset = $_.assets | ? {$_.browser_download_url -like "*ccache-*-windows-x86_64.zip" -or $_.browser_download_url -like "*ccache-*-windows-64.zip"}
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