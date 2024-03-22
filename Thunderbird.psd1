@{
	ListVersions = {
		Invoke-WebRequest -UseBasicParsing "https://releases.mozilla.org/pub/thunderbird/releases/" `
            | % Links `
            | % {if ($_.href -match "^/pub/thunderbird/releases/([0-9.]+.*)/$") {$Matches[1]}} `
            | ? {[int]($_ -split "\.")[0] -ge 61} # filter out versions earlier than 61, there's no precomputed SHA256 (only SHA512)
	}

	Generate = {
		param($Version)
		$Response = Invoke-WebRequest -UseBasicParsing "https://releases.mozilla.org/pub/thunderbird/releases/$Version/SHA256SUMS" | % Content
		$Hash = $Response -split "`n" | ? {$_ -like "* win64/en-US/Thunderbird Setup *.exe"} | % {($_ -split "  ")[0].ToUpper()}

		return [ordered]@{
			Version = $Version
			Hash = $Hash
		}
	}
}