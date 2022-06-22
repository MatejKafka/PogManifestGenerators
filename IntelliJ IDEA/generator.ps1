param(
		[Parameter(Mandatory)]
		[string]
	$Version,
		[Parameter(Mandatory)]
		[string]
	$TargetDir
)

# get download hash
$HashUrl = "https://download.jetbrains.com/idea/ideaIU-${Version}.win.zip.sha256"
try {
	$Response = (iwr $HashUrl).Content
	$Hash = ($Response -split " ")[0]
} catch {
	throw "Could not retrieve hash for the InteliJ IDEA version '$Version'. Are you sure it is a valid version? (URL: '$HashUrl')"
}

# clear target dir
rm -Recurse $TargetDir\*

# copy all files except for the manifest itself
cp -Recurse $PSScriptRoot\res\.pog $TargetDir\.pog

$Manifest = if ((New-PackageVersion $Version) -ge (New-PackageVersion 2021.2)) {
	# versions since 2021.2 do not support 32-bit x86 anymore
	cat -Raw "$PSScriptRoot\res\pog.psd1"
} else {
	# older versions support both x86 and x64 from a single package
	cat -Raw "$PSScriptRoot\res\pog_older-versions.psd1"
}

# set version and hash inside the manifest template
$Manifest = $Manifest -replace "{{VERSION}}", ($Version -replace '"', '``"')
$Manifest = $Manifest -replace "{{HASH}}", ($Hash -replace '"', '``"')
# write out the manifest file
$Manifest | Out-File $TargetDir\pog.psd1 -NoNewline
