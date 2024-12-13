@{
    # alpha versions are only available from https://autohotkey.com, github releases only contain stable versions
    ListVersions = {
        foreach ($v in "2.0", "2.1") {
            $BaseUrl = "https://www.autohotkey.com/download/$v/"
            try {
                $Links = (Invoke-WebRequest $BaseUrl).Links.href
            } catch {
                if ($_ -notlike "*Just a moment...*") {
                    throw
                }
                Write-Warning "CloudFlare bot protection on autohotkey.com was triggered, AutoHotkey will not be updated."
                return
            }

            foreach ($_ in $Links) {
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