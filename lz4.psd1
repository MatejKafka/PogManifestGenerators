@{
	ListVersions = {
		return Invoke-RestMethod -UseBasicParsing -FollowRelLink "https://api.github.com/repos/lz4/lz4/releases" `
			| % {$_} <# split single array to separate pipeline items #> `
			| ? {$_.tag_name.StartsWith("v") -and $_.tag_name -ne "v1.8.1"} <# v1.8.1 does not have binaries #> `
			| % {@{
				Version = $_.tag_name.Substring(1)
                Url = $_.assets | ? {$_.name.Contains("win64")} | % browser_download_url
			}}
	}

    Generate = {
        return [ordered]@{
            Version = $_.Version
            Url = $_.Url
            Hash = Get-UrlHash $_.Url
        }
    }
}