param(
		[Parameter(Mandatory)]
		[string]
	$Version,
		[Parameter(Mandatory)]
		[string]
	$TargetDir
)

$Response = Invoke-WebRequest "https://releases.mozilla.org/pub/firefox/releases/$Version/SHA256SUMS" | % Content
$Hash = $Response -split "`n" | ? {$_ -like "* win64/en-US/Firefox*.exe"} | % {($_ -split "  ")[0].ToUpper()}

# clear target dir
rm -Recurse $TargetDir\*

# copy all files except for the manifest itself
cp -Recurse $PSScriptRoot\res\.pog $TargetDir\.pog

# set version and hash inside the manifest template
$Manifest = cat -Raw $PSScriptRoot\res\pog.psd1
$Manifest = $Manifest -replace "{{VERSION}}", $Version
$Manifest = $Manifest -replace "{{HASH}}", $Hash
# write out the manifest file
$Manifest | Out-File $TargetDir\pog.psd1 -NoNewline
