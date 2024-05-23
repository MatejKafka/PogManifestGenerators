@{
    ListVersions = {
        foreach ($r in Invoke-RestMethod "https://go.dev/dl/?mode=json&include=all" | % {$_}) {
            if (-not $r.stable) {
                continue
            }

            $Hash = $r.files | ? filename -like "*.windows-amd64.zip" | % sha256 | % ToUpper
            if ($Hash) {
                [ordered]@{
                    Version = $r.version.Substring(2)
                    Hash = $Hash
                }
            }
        }
    }
}