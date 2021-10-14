$Versions = Invoke-RestMethod "https://golang.org/dl/?mode=json&include=all"

$Versions
	| ? {$_.stable}
	| select -ExpandProperty version
	| % {$_.Substring(2)}