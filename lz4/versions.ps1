Invoke-RestMethod "https://api.github.com/repos/lz4/lz4/releases"
	| % {$_.tag_name}
	| ? {$_.StartsWith("v")}
	| % {$_.Substring(1)}
	| ? {$_ -ne "1.8.1"} # does not have binaries