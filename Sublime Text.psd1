@{
    ListVersions = {
        return (Invoke-WebRequest https://www.sublimetext.com/download) -split "`n" `
            | Select-String '<h3>Build (\d+)</h3>' `
            | % {$_.Matches.Groups[1].Value}
    }

    Generate = {
        $Version = $_
        return [ordered]@{
            Version = $Version
            Hash = Get-UrlHash "https://download.sublimetext.com/sublime_text_build_${Version}_x64.zip"
        }
    }
}