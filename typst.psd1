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
        $Version = $_.Version
        $Url = $_.Url

        # get download hash
        Write-Verbose "Downloading archive for typst, version '$Version' to calculate the hash..."
        try {
            $ArchiveBytes = (Invoke-WebRequest -UseBasicParsing $Url).Content
        } catch {
            throw "Could not download the archive for typst, version '$Version' to calculate the hash: $_ (URL: '$Url')"
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