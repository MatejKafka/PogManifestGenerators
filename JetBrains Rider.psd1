@{
    ListVersions = {
        Invoke-WebRequest https://www.jetbrains.com/updates/updates.xml `
            | Select-Xml '/products/product[@name="Rider"]/channel[@name="Rider RELEASE"]/build/@version' `
            | % {$_.Node.'#text'} `
            | ? {-not $_.StartsWith("2017") -and $_ -ne "2018.1.4"} <# these old version have a different URL format #> `
            | % {if ($_ -eq "2020.1") {"2020.1.0"} else {$_}} <# this version has an added .0 patch version, not sure why #>
    }

    Generate = {
        param($Version)

        return [ordered]@{
            Version = $Version
            Hash = Get-HashFromChecksumFile `
                "https://download.jetbrains.com/rider/JetBrains.Rider-${Version}.win.zip.sha256" `
                "*JetBrains.Rider-${Version}.win.zip"
        }
    }
}