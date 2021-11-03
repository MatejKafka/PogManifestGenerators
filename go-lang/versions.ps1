$Versions = Invoke-RestMethod "https://golang.org/dl/?mode=json&include=all"

$Versions
	| ? {$_.stable}
	| % {[pscustomobject]@{
		Version = $_.version.Substring(2)
		Hash = $_.files | ? {$_.filename.EndsWith(".windows-amd64.zip")} | % sha256 | ? {$_}
	}}
	| ? {$null -ne $_.Hash}