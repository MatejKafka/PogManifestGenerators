param(
		[Parameter(Mandatory)]
		[string]
	$Version,
		[Parameter(Mandatory)]
		[string]
	$TargetDir
)

# get download hash
$HashUrl = "https://download.jetbrains.com/rider/JetBrains.Rider-${Version}.win.zip.sha256"
try {
	$Response = (iwr $HashUrl).Content
	$Hash = ($Response -split " ")[0]
} catch {
	throw "Could not retrieve hash for the JetBrains Rider version '$Version'. Are you sure it is a valid version? (URL: '$HashUrl')"
}

# clear target dir
rm -Recurse $TargetDir\*

# copy all files except for the manifest itself
cp -Recurse $PSScriptRoot\res\.pog $TargetDir\.pog

# set version and hash inside the manifest template
$Manifest = cat -Raw $PSScriptRoot\res\pog.psd1
$Manifest = $Manifest -replace "{{VERSION}}", ($Version -replace '"', '``"')
$Manifest = $Manifest -replace "{{HASH}}", ($Hash -replace '"', '``"')
# write out the manifest file
$Manifest | Out-File $TargetDir\pog.psd1 -NoNewline
