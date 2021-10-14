param(
		[Parameter(Mandatory)]
		[string]
	$Version,
		[Parameter(Mandatory)]
		[string]
	$TargetDir
)

# get download hash
# for some reason, the .sha256 hash file is not available on golang.org/dl/..., only directly on Google Cloud URL
$HashUrl = "https://dl.google.com/go/go${Version}.windows-amd64.zip.sha256"
try {
	$Hash = (iwr $HashUrl).Content
} catch {
	throw "Could not retrieve hash for the go-lang version '$Version'. Are you sure it is a valid version? (URL: '$HashUrl')"
}

# clear target dir
rm -Recurse $TargetDir\*
mkdir $TargetDir\.manifest

# copy all files except for the manifest itself
cp -Recurse $PSScriptRoot\res\* -Exclude manifest.psd1 $TargetDir\.manifest

# set version and hash inside the manifest template
$Manifest = cat -Raw $PSScriptRoot\res\manifest.psd1
$Manifest = $Manifest -replace "{{VERSION}}", ($Version -replace '"', '``"')
$Manifest = $Manifest -replace "{{HASH}}", ($Hash -replace '"', '``"')
# write out the manifest file
$Manifest | Out-File $TargetDir\.manifest\manifest.psd1 -NoNewline