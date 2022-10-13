Invoke-WebRequest "https://releases.mozilla.org/pub/firefox/releases/" `
	| % Links `
	| % {if ($_.href -match "^/pub/firefox/releases/([0-9.]+.*)/$") {$Matches[1]}} `
	# filter out ESR, funnelcake and similar extra versions
	| ? {$_ -match "^[0-9.]+(b[0-9]*)?$"} `
	# filter out versions earlier than 53, they did not have SHA-256 hashes precomputed, only SHA-512 (also, versions before 42 do not have an x64 build)
	| ? {[int]($_ -split "\.")[0] -ge 53}
