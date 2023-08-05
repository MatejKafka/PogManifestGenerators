@{
    ListVersions = {
        Invoke-WebRequest https://www.jetbrains.com/updates/updates.xml `
            | Select-Xml '/products/product[@name="Rider"]/channel[@name="Rider RELEASE"]/build/@version'
            | % {$_.Node.'#text'}
            # these old version have a different URL format
            | ? {-not $_.StartsWith("2017") -and $_ -ne "2018.1.4"}
            # this version has an added .0 patch version, not sure why
            | % {if ($_ -eq "2020.1") {"2020.1.0"} else {$_}}
    }

    Generate = {
        $Version = $_
        # get download hash
        $HashUrl = "https://download.jetbrains.com/rider/JetBrains.Rider-${Version}.win.zip.sha256"
        try {
            $Response = (iwr $HashUrl).Content
            $Hash = ($Response -split " ")[0]
        } catch {
            throw "Could not retrieve hash for the JetBrains Rider version '$Version'. Are you sure it is a valid version? (URL: '$HashUrl')"
        }

        return [ordered]@{
            Version = $Version
            Hash = $Hash
        }
    }
}