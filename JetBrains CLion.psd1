@{
	ListVersions = {
		Invoke-WebRequest https://www.jetbrains.com/updates/updates.xml `
			| Select-Xml '/products/product[@name="CLion"]/channel[@name="CLion RELEASE"]/build/@version' `
			| % {$_.Node.'#text'} `
			| ? {[int]($_ -split "\.",2)[0] -gt 2018} <# 2018 and earlier releases have a different download URL format, ignore them #>
	}

	Generate = {
		param($Version)
		# get download hash
		$HashUrl = "https://download.jetbrains.com/cpp/CLion-${Version}.win.zip.sha256"
		try {
			$Response = (Invoke-WebRequest $HashUrl).Content
			$Hash = ($Response -split " ")[0]
		} catch {
			throw "Could not retrieve hash for the CLion version '$Version'. Are you sure it is a valid version? (URL: '$HashUrl')"
		}

		return [ordered]@{
			Version = $Version
        	Hash = Get-HashFromChecksumFile "https://download.jetbrains.com/cpp/CLion-${Version}.win.zip.sha256" "*CLion-${Version}.win.zip"
		}
	}
}