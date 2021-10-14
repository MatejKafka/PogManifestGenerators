Invoke-WebRequest https://www.jetbrains.com/updates/updates.xml `
	| Select-Xml '/products/product[@name="CLion"]/channel[@name="CLion RELEASE"]/build/@version' `
	| % {$_.Node.'#text'}
	# 2018 and earlier releases have a different download URL format, ignore them
	| ? {[int]($_ -split "\.",2)[0] -gt 2018}