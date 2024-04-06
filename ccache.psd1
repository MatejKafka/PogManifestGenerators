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
        $Version = $_.Version
        $Url = $_.Url

        # get download hash
        Write-Verbose "Downloading archive for ccache, version '$Version' to calculate the hash..."
        try {
            $ArchiveBytes = (Invoke-WebRequest -UseBasicParsing $Url).Content
        } catch {
            throw "Could not download the archive for ccache, version '$Version' to calculate the hash: $_ (URL: '$Url')"
        }
        $RawHash = [System.Security.Cryptography.SHA256]::HashData($ArchiveBytes)
        $Hash = [System.BitConverter]::ToString($RawHash).Replace("-", "")

        return [ordered]@{
            Version = $Version
            Url = $Url
            Hash = $Hash
        }
    }
}