Invoke-WebRequest https://www.jetbrains.com/updates/updates.xml `
	| Select-Xml '/products/product[@name="IntelliJ IDEA"]/channel[@name="IntelliJ IDEA RELEASE"]/build/@version' `
	| % {$_.Node.'#text'}