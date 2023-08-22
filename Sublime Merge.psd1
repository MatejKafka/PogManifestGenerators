@{
    ListVersions = {
        return (Invoke-WebRequest -UseBasicParsing https://www.sublimemerge.com/download) -split "`n" `
            | Select-String '<h3>Build (\d+)</h3>' `
            | % {$_.Matches.Groups[1].Value}
    }

    Generate = {
        param($Version)

        $SrcUrl = "https://download.sublimetext.com/sublime_merge_build_${Version}_x64.zip"

        try {$InstallerBytes = (Invoke-WebRequest -UseBasicParsing $SrcUrl).Content}
        catch {throw "Could not download the archive to calculate a hash: $_ (URL: '$SrcUrl')"}

        $RawHash = [System.Security.Cryptography.SHA256]::HashData($InstallerBytes)
        $Hash = [System.BitConverter]::ToString($RawHash).Replace("-", "")

        @{
            Version = $Version
            Hash = $Hash
        }
    }
}