@{
    ListVersions = {
        param($ExistingVersions)

        $Releases = Invoke-RestMethod -UseBasicParsing https://curl.se/docs/releases.csv `
            | ConvertFrom-Csv -Delimiter ";" -Header "Index", "Version" `
            | % Version `
            | ? {[version]$_ -ge [version]"7.80.0"} 

        # each release may have multiple builds; I haven't found anything better than to just try to list them by brute-force
        foreach ($Version in $Releases) {
            for ($i = 1;; $i++) {
                $Build = "${Version}_${i}"

                if ($ExistingVersions.Contains($Build)) {
                    echo $Build
                    continue
                }

                Write-Verbose "Trying build '${Build}'..."
                try {
                    $null = Invoke-WebRequest -UseBasicParsing "https://curl.se/windows/dl-${Build}/" -Method HEAD
                    echo $Build
                } catch {
                    break
                }
            }
            
        }
    }

    Generate = {
        $Hashes = Invoke-WebRequest -UseBasicParsing "https://curl.se/windows/dl-${_}/hashes.txt"
        $Hash = ($Hashes -split "`n" | Select-String "-win64-mingw.zip\)= ([0-9a-f]{64})").Matches[0].Groups[1].Value.ToUpper()
        
        return @{
            Version = $_
            Hash = $Hash
        }
    }
}