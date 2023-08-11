@{
	ListVersions = {
		return Invoke-RestMethod -UseBasicParsing "https://api.github.com/repos/lz4/lz4/releases" `
			| % {$_} <# split single array to separate pipeline items #> `
			| ? {$_.tag_name.StartsWith("v") -and $_.tag_name -ne "v1.8.1"} <# v1.8.1 does not have binaries #> `
			| % {@{
				Version = $_.tag_name.Substring(1)
				AssetsUrl = $_.assets_url
			}}
	}

	Generate = {
        $Version = $_.Version
		$Url = Invoke-RestMethod $_.AssetsUrl `
			| % {$_} <# split single array to separate pipeline items #> `
			| ? {$_.name.Contains("win64")} `
			| % {$_.browser_download_url}

		# get download hash
		Write-Verbose "Downloading archive for lz4, version '$Version' to calculate the hash..."
		try {
			$ArchiveBytes = (Invoke-WebRequest -UseBasicParsing $Url).Content
		} catch {
			throw "Could not download the archive for lz4, version '$Version' to calculate the hash: $_ (URL: '$Url')"
		}
		$RawHash = [System.Security.Cryptography.SHA256]::HashData($ArchiveBytes)
		$Hash = [System.BitConverter]::ToString($RawHash).Replace("-", "")

		return [ordered]@{
			Version = $Version
			Url = $Url
			Hash = $Hash
		}
	}
}