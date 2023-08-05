@{
	ListVersions = {
		Invoke-WebRequest https://www.jetbrains.com/updates/updates.xml `
			| Select-Xml '/products/product[@name="CLion"]/channel[@name="CLion RELEASE"]/build/@version' `
			| % {$_.Node.'#text'}
			# 2018 and earlier releases have a different download URL format, ignore them
			| ? {[int]($_ -split "\.",2)[0] -gt 2018}
	}

	Generate = {
		$Version = $_
		# get download hash
		$HashUrl = "https://download.jetbrains.com/cpp/CLion-${Version}.win.zip.sha256"
		try {
			$Response = (iwr $HashUrl).Content
			$Hash = ($Response -split " ")[0]
		} catch {
			throw "Could not retrieve hash for the CLion version '$Version'. Are you sure it is a valid version? (URL: '$HashUrl')"
		}

		return [ordered]@{
			Version = $Version
			Hash = $Hash
		}
	}
}