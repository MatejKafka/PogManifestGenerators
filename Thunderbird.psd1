@{
	ListVersions = {
		return Invoke-WebRequest "https://releases.mozilla.org/pub/thunderbird/releases/" `
            | % Links `
            | % {if ($_.href -match "^/pub/thunderbird/releases/([0-9.]+.*)/$") {$Matches[1]}} `
            | ? {[int]($_ -split "\.")[0] -ge 61} <# filter out versions earlier than 61, there's no precomputed SHA256 (only SHA512) #> `
            | ? {$_ -notlike "79.0b?"} <# these beta versions have invalid hash format #>
	}

	Generate = {
		param($Version)

		return [ordered]@{
			Version = $Version
			Hash = Get-HashFromChecksumFile `
				"https://releases.mozilla.org/pub/thunderbird/releases/$Version/SHA256SUMS" `
				"win64/en-US/Thunderbird Setup $Version.exe"
		}
	}
}