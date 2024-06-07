@{
    ListVersions = {
        Get-GitHubRelease notepad-plus-plus/notepad-plus-plus `
            | ? {$_.tag_name.StartsWith("v")} `
            | % {
                $Asset = $_.assets | ? name -like "npp.*.portable.x64.7z"
                if ($Asset) {
                    return [ordered]@{
                        Version = $_.tag_name.Substring(1)
                        Url = $Asset.browser_download_url
                        Hash = Get-HashFromChecksumText $_.body $Asset.name
                    }
                }
            }
    }
}