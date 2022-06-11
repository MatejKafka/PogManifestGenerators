Invoke-WebRequest https://www.jetbrains.com/updates/updates.xml `
	| Select-Xml '/products/product[@name="Rider"]/channel[@name="Rider RELEASE"]/build/@version'
	| % {$_.Node.'#text'}
	# these old version have a different URL format
	| ? {-not $_.StartsWith("2017") -and $_ -ne "2018.1.4"}
	# this version has an added .0 patch version, not sure why
	| % {if ($_ -eq "2020.1") {"2020.1.0"} else {$_}}
