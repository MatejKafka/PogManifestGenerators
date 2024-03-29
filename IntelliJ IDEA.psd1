@{
    ListVersions = {
        Invoke-WebRequest -UseBasicParsing https://www.jetbrains.com/updates/updates.xml `
            | Select-Xml '/products/product[@name="IntelliJ IDEA"]/channel[@name="IntelliJ IDEA RELEASE"]/build/@version' `
            | % {$_.Node.'#text'}
    }

    Generate = {
        param($Version)
        # get download hash
        $HashUrl = "https://download.jetbrains.com/idea/ideaIU-${Version}.win.zip.sha256"
        try {
            $Response = (Invoke-WebRequest -UseBasicParsing $HashUrl).Content
            $Hash = ($Response -split " ")[0]
        } catch {
            throw "Could not retrieve hash for the InteliJ IDEA version '$Version'. Are you sure it is a valid version? (URL: '$HashUrl')"
        }

        return [ordered]@{
            Version = $Version
            Hash = $Hash
        }
    }
}