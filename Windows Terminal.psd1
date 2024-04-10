@{
	ListVersions = {
		Invoke-RestMethod -UseBasicParsing "https://api.github.com/repos/microsoft/terminal/releases" `
			| % {$_} <# split up the single returned list from I-RM to pipeline objects #> `
			| ? {[version]$_.tag_name.Substring(1) -ge [version]"1.17.11391.0"}
			| % {@{
				Version = $_.tag_name.Substring(1) # strip v...
				Url = $_.assets | ? name -like "*_x64.zip" | % browser_download_url
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