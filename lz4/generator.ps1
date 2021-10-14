param(
		[Parameter(Mandatory)]
		[string]
	$Version,
		[Parameter(Mandatory)]
		[string]
	$TargetDir
)

# get download URL
$AssetsUrl = Invoke-RestMethod "https://api.github.com/repos/lz4/lz4/releases"
	| % {$_} # split single array to separate pipeline items
	| ? {$_.tag_name -eq ("v" + $Version)}
	| % {$_.assets_url}

$Url = Invoke-RestMethod $AssetsUrl
	| % {$_} # split single array to separate pipeline items
	| ? {$_.name.Contains("win64")}
	| % {$_.browser_download_url}

# get download hash
Write-Verbose "Downloading archive for lz4, version '$Version' to calculate the hash..."
try {
	$ArchiveBytes = (Invoke-WebRequest $Url).Content
} catch {
	throw "Could not download the archive for lz4, version '$Version' to calculate the hash: $_ (URL: '$Url')"
}
$RawHash = [System.Security.Cryptography.SHA256]::HashData($ArchiveBytes)
$Hash = [System.BitConverter]::ToString($RawHash).Replace("-", "")

# clear target dir
rm -Recurse $TargetDir\*

# set version and hash inside the manifest template
$Manifest = cat -Raw $PSScriptRoot\res\pog.psd1
$Manifest = $Manifest -replace "{{VERSION}}", ($Version -replace '"', '``"')
$Manifest = $Manifest -replace "{{HASH}}", ($Hash -replace '"', '``"')
$Manifest = $Manifest -replace "{{URL}}", ($Url -replace '"', '``"')
# write out the manifest file
$Manifest | Out-File $TargetDir\pog.psd1 -NoNewline