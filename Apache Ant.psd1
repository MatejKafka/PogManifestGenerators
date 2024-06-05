@{
    ListVersions = {
        $BaseUrl = "https://archive.apache.org/dist/ant/binaries/"
        foreach ($_ in (Invoke-WebRequest $BaseUrl).Links.href) {
            if ($_ -notmatch "^apache-ant-([\d\.\-]+)-bin\.zip$") {
                continue
            }

            @{
                Version = $Matches[1]
                Url = $BaseUrl + $_
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