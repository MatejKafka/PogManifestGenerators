@{
    ListVersions = {
        "2.0", "2.1" | % {
            $BaseUrl = "https://www.autohotkey.com/download/$_/"
            foreach ($_ in (Invoke-WebRequest $BaseUrl).Links.href) {
                if ($_ -notmatch "^AutoHotkey_v?(\d.*)\.zip$" -or $_ -like "*_x64.zip") {
                    continue
                }

                @{
                    Version = $Matches[1]
                    Url = "$BaseUrl$_"
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