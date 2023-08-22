@{
    ListVersions = {
        Invoke-RestMethod -UseBasicParsing "https://sourceforge.net/projects/qbittorrent/rss?path=/qbittorrent-win32" | % {
            if ($_.title.InnerText -notmatch "^/qbittorrent-win32/qbittorrent-(.*)/qbittorrent_(.*)_x64_setup.exe$") {
                return
            }
            if ($Matches[1] -eq $Matches[2]) {
                return $Matches[1]
            }
        }
    }

    Generate = {
        param($Version)
        # get download hash
        $InstallerUrl = "https://downloads.sourceforge.net/project/qbittorrent/qbittorrent-win32/" +`
                    "qbittorrent-${Version}/qbittorrent_${Version}_x64_setup.exe"
        Write-Verbose "Downloading installer for qBittorrent, version '$Version' to calculate the hash..."
        try {
            # the installer is only ~25MB large, so it's acceptable to download it to calculate the hash
            $InstallerBytes = (Invoke-WebRequest -UseBasicParsing $InstallerUrl -UserAgent "Wget").Content
        } catch {
            throw "Could not download the installer for qBittorrent, version '$Version' to calculate the hash: $_ (URL: '$InstallerUrl')"
        }
        $RawHash = [System.Security.Cryptography.SHA256]::HashData($InstallerBytes)
        $Hash = [System.BitConverter]::ToString($RawHash).Replace("-", "")

        return [ordered]@{
            Version = $Version
            Hash = $Hash
        }
    }
}