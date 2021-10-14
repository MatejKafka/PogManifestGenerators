param(
		[Parameter(Mandatory)]
		[string]
	$Version,
		[Parameter(Mandatory)]
		[string]
	$TargetDir
)

# get download hash
$InstallerUrl = "https://downloads.sourceforge.net/project/qbittorrent/qbittorrent-win32/" +`
			"qbittorrent-${Version}/qbittorrent_${Version}_x64_setup.exe"
Write-Verbose "Downloading installer for qBittorrent, version '$Version' to calculate the hash..."
try {
	# the installer is only ~25MB large, so it's acceptable to download it to calculate the hash
	$InstallerBytes = (Invoke-WebRequest $InstallerUrl -UserAgent "Wget").Content
} catch {
	throw "Could not download the installer for qBittorrent, version '$Version' to calculate the hash: $_ (URL: '$InstallerUrl')"
}
$RawHash = [System.Security.Cryptography.SHA256]::HashData($InstallerBytes)
$Hash = [System.BitConverter]::ToString($RawHash).Replace("-", "")

# clear target dir
rm -Recurse $TargetDir\*

# set version and hash inside the manifest template
$Manifest = cat -Raw $PSScriptRoot\res\pog.psd1
$Manifest = $Manifest -replace "{{VERSION}}", ($Version -replace '"', '``"')
$Manifest = $Manifest -replace "{{HASH}}", ($Hash -replace '"', '``"')
# write out the manifest file
$Manifest | Out-File $TargetDir\pog.psd1 -NoNewline