@{
	ListVersions = {
		Invoke-RestMethod "https://api.github.com/repos/nim-lang/Nim/tags"
			| % {$_} # split up the single returned list from I-RM to pipeline objects
			| % {$_.name}
			| ? {$_.StartsWith("v")}
			| % {$_.Substring(1)}
			| ? {-not $_.StartsWith("0.")} # skip versions before 1.0.0
			| ? {$_ -notin @("1.0.0", "1.0.2")} # these do not support --clearNimblePath
	}

	Generate = {
		$Version = $_
		# get download hash
		Write-Verbose "Downloading hash for nim-lang, version '$Version'..."
		$HashUrl = "https://nim-lang.org/download/nim-${Version}_x64.zip.sha256"
		try {
			$Response = Invoke-WebRequest $HashUrl
			$HashStr = [System.Text.Encoding]::UTF8.GetString($Response.Content)
			$Hash = ($HashStr -split " ")[0]
		} catch {
			throw "Could not download the hash file for nim-lang, version '$Version': $_ (URL: '$HashUrl')"
		}

		return [ordered]@{
			Version = $Version
			Hash = $Hash
		}
	}
}