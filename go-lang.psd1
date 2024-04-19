@{
    ListVersions = {
        Invoke-RestMethod -UseBasicParsing "https://go.dev/dl/?mode=json&include=all" `
            | % {$_} `
            | ? {$_.stable} `
            | % {[ordered]@{
                Version = $_.version.Substring(2)
                Hash = $_.files | ? {$_.filename.EndsWith(".windows-amd64.zip")} | % sha256 | ? {$_} | % {$_.ToUpper()}
            }} `
            | ? {$null -ne $_.Hash}
    }
}