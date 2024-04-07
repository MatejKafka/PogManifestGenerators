@{
    ListVersions = {
        return Invoke-RestMethod -UseBasicParsing -FollowRelLink "https://api.github.com/repos/typst/typst/releases" `
            | % {$_} <# split single array to separate pipeline items #> `
            | ? {$_.tag_name.StartsWith("v") -and $_.tag_name -notlike "v23-03-*"} `
            | % {@{
                Version = $_.tag_name.Substring(1)
                Url = $_.assets | ? browser_download_url -like "*typst-x86_64-pc-windows-msvc.zip" | % browser_download_url
            }}
    }

    Generate = {
        return [ordered]@{
            Version = $_.Version
            Url = $_.Url
            Hash = Get-UrlHash $_.Url
        }
    }
}