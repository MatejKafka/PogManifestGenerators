param(
		[Parameter(Mandatory)]
		[string]
	$Version,
		[Parameter(Mandatory)]
		[string]
	$TargetDir
)

# get download hash
Write-Verbose "Downloading archive for nim-lang, version '$Version' to calculate the hash..."
$HashUrl = "https://nim-lang.org/download/nim-${Version}_x64.zip.sha256"
try {
	$Response = Invoke-WebRequest $HashUrl
	$HashStr = [System.Text.Encoding]::UTF8.GetString($Response.Content)
	$Hash = ($HashStr -split " ")[0]
} catch {
	throw "Could not download the hash file for nim-lang, version '$Version': $_ (URL: '$HashUrl')"
}

# clear target dir
rm -Recurse $TargetDir\*
mkdir $TargetDir\.pog

# copy all files except for the manifest itself
cp -Recurse $PSScriptRoot\res\* -Exclude pog.psd1 $TargetDir\.pog

# set version and hash inside the manifest template
$Manifest = cat -Raw $PSScriptRoot\res\pog.psd1
$Manifest = $Manifest -replace "{{VERSION}}", ($Version -replace '"', '``"')
$Manifest = $Manifest -replace "{{HASH}}", ($Hash -replace '"', '``"')
# write out the manifest file
$Manifest | Out-File $TargetDir\.pog\pog.psd1 -NoNewline