param(
		[Parameter(Mandatory)]
		[hashtable]
	$VersionData,
		[Parameter(Mandatory)]
		[string]
	$TargetDir
)

# clear target dir
rm -Recurse $TargetDir\*

# copy all files except for the manifest itself
cp -Recurse $PSScriptRoot\res\.pog $TargetDir\.pog

# set version and hash inside the manifest template
$Manifest = cat -Raw $PSScriptRoot\res\pog.psd1
$Manifest = $Manifest -replace "{{VERSION}}", ($VersionData.Version -replace '"', '``"')
$Manifest = $Manifest -replace "{{HASH}}", ($VersionData.Hash -replace '"', '``"')
# write out the manifest file
$Manifest | Out-File $TargetDir\pog.psd1 -NoNewline
