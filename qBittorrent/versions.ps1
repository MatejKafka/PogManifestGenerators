Invoke-RestMethod "https://sourceforge.net/projects/qbittorrent/rss?path=/qbittorrent-win32" | % {
	if ($_.title.InnerText -notmatch "^/qbittorrent-win32/qbittorrent-(.*)/qbittorrent_(.*)_x64_setup.exe$") {
		return
	}
	if ($Matches[1] -eq $Matches[2]) {
		return $Matches[1]
	}
}
