@{
	ListVersions = {
		Get-GitHubRelease -Tags nim-lang/Nim `
			| % {$_.name} `
			| ? {$_.StartsWith("v")} `
			| % {$_.Substring(1)} `
			| ? {-not $_.StartsWith("0.")} <# skip versions before 1.0.0 #> `
			| ? {$_ -notin @("1.0.0", "1.0.2")} <# these do not support --clearNimblePath #>
	}

	Generate = {
		param($Version)

		return [ordered]@{
			Version = $Version
			Hash = Get-HashFromChecksumFile "https://nim-lang.org/download/nim-${Version}_x64.zip.sha256" "nim-${Version}_x64.zip"
		}
	}
}