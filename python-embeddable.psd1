@{
    ListVersions = {
        foreach ($l in (iwr "https://www.python.org/downloads/windows/").Links) {
            if ($l.href -match "https://www.python\.org/ftp/python/(.*)/python-(.*)-embed-amd64\.zip") {
                @{
                    Version = $Matches[2]
                    Url = $l.href
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