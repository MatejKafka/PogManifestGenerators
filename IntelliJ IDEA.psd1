@{
    ListVersions = {
        Invoke-WebRequest https://www.jetbrains.com/updates/updates.xml `
            | Select-Xml '/products/product[@name="IntelliJ IDEA"]/channel[@name="IntelliJ IDEA RELEASE"]/build/@version' `
            | % {$_.Node.'#text'}
    }

    Generate = {
        param($Version)

        return [ordered]@{
            Version = $Version
            Hash = Get-HashFromChecksumFile "https://download.jetbrains.com/idea/ideaIU-${Version}.win.zip.sha256" "*ideaIU-${Version}.win.zip"
        }
    }
}