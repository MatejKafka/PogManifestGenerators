Invoke-RestMethod "https://api.github.com/repos/nim-lang/Nim/tags"
	| % {$_.name}
	| ? {$_.StartsWith("v")}
	| % {$_.Substring(1)}
	| ? {-not $_.StartsWith("0.")} # skip versions before 1.0.0
	| ? {$_ -notin @("1.0.0", "1.0.2")} # these do not support --clearNimblePath