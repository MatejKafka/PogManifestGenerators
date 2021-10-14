Invoke-RestMethod "https://sourceforge.net/projects/qbittorrent/rss?path=/qbittorrent-win32"
	| % {$_.title.InnerText}
	| ? {$_.EndsWith("x64_setup.exe")}
	| % {(($_ -split "/")[2] -split "-")[1]} # extract the version from the file path
	                                         # example: /qbittorrent-win32/qbittorrent-4.3.8/qbittorrent_4.3.8_x64_setup.exe