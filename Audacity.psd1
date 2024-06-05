@{
    ListVersions = {
        foreach ($r in Get-GitHubRelease audacity/audacity) {
            if (-not $r.assets) {
                continue # early versions do not have binaries
            }

            if ($r.tag_name -notmatch "^Audacity-(.*)$") {
                continue
            }
            $Version = $Matches[1]

            if ($Version -in "3.0.3-RC1", "3.2.4", "3.0.2", "3.0.0") {
                continue # Audacity really loves inconsistency
            }

            $Asset = $r.assets | ? name -match "^audacity-win-.*-(x64|64bit|x64bit)\.zip$"
            if (-not $Asset) {
                throw "Missing binaries for version '$Version'."
            }

            @{
                Version = $Version
                ZipAsset = $Asset
                ChecksumAsset = $r.assets | ? name -eq "CHECKSUMS.txt"
            }
        }
    }

    Generate = {
        return [ordered]@{
            Version = $_.Version
            Url = $_.ZipAsset.browser_download_url
            Hash = if ($_.ChecksumAsset) {
                # Audacity just dumps a PowerShell formatted table to the checksum file
                $Line = (iwr $_.ChecksumAsset.browser_download_url) -split "`n" | Select-String $_.ZipAsset.name -Raw
                $Hash = -split $Line | ? Length -eq 64
                if (-not $Hash) {throw "Could not find hash."}
                $Hash.ToUpperInvariant()
            } else {
                Get-UrlHash $_.ZipAsset.browser_download_url
            }
        }
    }
}